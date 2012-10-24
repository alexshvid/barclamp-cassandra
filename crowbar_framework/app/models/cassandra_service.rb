#
# Cookbook Name: cassandra
# Recipe: cassandra_service.rb
#
# Copyright (c) 2012 Mirantis, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class CassandraService < ServiceObject

  def initialize(thelogger)
    @bc_name = "cassandra"
    @logger = thelogger
  end

  def validate_proposal proposal
    super proposal

    val = proposal["attributes"]["cassandra"]["rpc_port"] rescue -1
    raise I18n.t('barclamp.cassandra.edit_attributes.rpc_port_error') if val < 0
  end

  def create_proposal
    @logger.debug("cassandra create_proposal: entering")
    base = super

    # Get the node list.
    nodes = NodeObject.all
    nodes.delete_if { |n| n.nil? or n.admin? }

    # Find the slave nodes for the cassandra servers.
    # The number of slaves to use depends on the number of failed
    # nodes to support. We follow the (2F+1) rule so we stop allocating
    # at the first 5 slave nodes found.
    servers_fqdns = Array.new
    node_cnt = 0
    nodes.each { |n|
      next if n.nil?
      if !n[:fqdn].nil? && !n[:fqdn].empty?
        servers_fqdns << n[:fqdn]
        node_cnt = node_cnt +1
        break if node_cnt >= 5
      end
    }

    # Check for errors or add the proposal elements.
    base["deployment"]["cassandra"]["elements"] = { }
    if !servers_fqdns.nil? && servers_fqdns.length > 0
      base["deployment"]["cassandra"]["elements"]["cassandra-server"] = servers_fqdns
    else
      @logger.debug("cassandra create_proposal: No server nodes found, proposal bind failed")
    end

    @logger.debug("cassandra create_proposal: exiting")
    base
  end

  def apply_role_pre_chef_call(old_role, role, all_nodes)
    @logger.debug("cassandra apply_role_pre_chef_call: entering #{all_nodes.inspect}")
    return if all_nodes.nil? or all_nodes.empty?

    # Retrieve old and new roles data
    old_servers = old_role.override_attributes["cassandra"]["elements"]["cassandra-server"] rescue []
    new_servers = role.override_attributes["cassandra"]["elements"]["cassandra-server"]
    old_cluster_name = old_role.default_attributes["cassandra"]["cluster_name"] rescue nil
    new_cluster_name = role.default_attributes["cassandra"]["cluster_name"]

    install_new = true
    install_new = false if not old_servers.empty? and old_cluster_name == new_cluster_name 
            
    @logger.debug("cassandra apply_role_pre_chef_call: old_servers #{old_servers.inspect}")
    @logger.debug("cassandra apply_role_pre_chef_call: new_servers #{new_servers.inspect}")
    @logger.debug("cassandra apply_role_pre_chef_call: old_cluster_name = #{old_cluster_name}")
    @logger.debug("cassandra apply_role_pre_chef_call: new_cluster_name = #{new_cluster_name}")
    @logger.debug("cassandra apply_role_pre_chef_call: install_new= #{install_new}")
    
    # Init tokens for new nodes and save directories for old nodes, bind_address and topology for all nodes     
    max_seeds = 2
    seeds = ""
    i = 0
    num = all_nodes.size
    topology = Array.new
    
    all_nodes.each do |n|
      node = NodeObject.find_node_by_name n
      node.crowbar[:cassandra] = {} if node.crowbar[:cassandra].nil?
      
      if install_new
        t = i * (2**127) / num
        node.crowbar[:cassandra][:initial_token] = t.to_s
        @logger.debug("cassandra apply_role_pre_chef_call: set initial_token #{t} to node #{n}")
      else
        if old_servers.include?(n)
          node.crowbar[:cassandra][:save_directories] = true
          @logger.debug("cassandra apply_role_pre_chef_call: save_directories=true for node #{n}")
        end
      end
      
      # Init bind address
      admin_address = node.get_network_by_type("admin")["address"]
      node.crowbar[:cassandra][:bind_address] = admin_address
        
      # Save node  
      node.save
      
      # Collect nodes for tolopogy
      topology << admin_address + "=DC1:R1"
      
      # Collect seeds
      if max_seeds > 0
        seeds << "," if not seeds.empty?
        seeds << admin_address
        max_seeds = max_seeds - 1
      end
      
      # increment iterator  
      i = i + 1
    end

    role.default_attributes["cassandra"]["seeds"] = seeds
    @logger.debug("cassandra apply_role_pre_chef_call: seeds #{seeds}")
    
    role.default_attributes["cassandra"]["keystore_password"] = random_password if role.default_attributes["cassandra"]["keystore_password"] == ""
    role.default_attributes["cassandra"]["truststore_password"] = random_password if role.default_attributes["cassandra"]["truststore_password"] == ""
    role.default_attributes["cassandra"]["topology"] = topology
    role.save

    @logger.debug("cassandra apply_role_pre_chef_call: leaving")
  end

end
