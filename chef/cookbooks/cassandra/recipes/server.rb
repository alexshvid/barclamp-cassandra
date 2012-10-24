#
# Cookbook Name: cassandra
# Recipe: server.rb
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

#######################################################################
# Begin recipe transactions
#######################################################################

debug = node[:cassandra][:debug]
Chef::Log.info("Cassandra: Begin cassandra:server") if debug

# Install the cassandra server package.
package "cassandra" do
  action :install
end

# Define the cassandra server service.
# {start|stop|restart|force-reload|status|force-stop}
service "cassandra" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

# Stop the cassandra service.
service "cassandra" do
  action :stop
end

# Update configuration files
template "/etc/cassandra/cassandra.yaml" do
  owner "cassandra"
  group "cassandra"
  mode "0644"
  source "cassandra.yaml.erb"
end

template "/etc/cassandra/log4j-server.properties" do
  owner "cassandra"
  group "cassandra"
  mode "0644"
  source "log4j-server.properties.erb"
end

template "/etc/cassandra/cassandra-env.sh" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-env.sh.erb"
end

template "/etc/init.d/cassandra" do
  owner "root"
  group "root"
  mode "0755"
  source "cassandra.erb"
end

template "/etc/cassandra/cassandra-topology.properties" do
  owner "cassandra"
  group "cassandra"
  mode "0644"
  source "cassandra-topology.properties.erb"
end

# Create directories for cassandra
directory File.dirname(node[:cassandra][:pid_file]) do
  owner "root"
  group "root"
  mode "0777"
  recursive true
  action :create
end

directory File.dirname(node[:cassandra][:output_file]) do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

directory node[:cassandra][:xx_directory] do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

save_directories = node[:cassandra][:save_directories]
Chef::Log.info("Cassandra: save_directories=#{save_directories}") if debug
  
node[:cassandra][:data_file_directories].strip.split(/[\s:;,]+/).each do |dir|
 
  execute "rm-data-dir" do
    user "root"
    group "root"
    command "rm -rf #{dir}"
    action :run
    not_if { save_directories }
  end
  
  directory dir do
    owner "cassandra"
    group "cassandra"
    mode "0700"
    recursive true
    action :create
  end
end

execute "rm-commitlog-dir" do
  user "root"
  group "root"
  command "rm -rf #{node[:cassandra][:commitlog_directory]}"
  action :run
  not_if { save_directories }
end

directory node[:cassandra][:commitlog_directory] do
  owner "cassandra"
  group "cassandra"
  mode "0700"
  recursive true
  action :create
end

execute "rm-saved-caches-dir" do
  user "root"
  group "root"
  command "rm -rf #{node[:cassandra][:saved_caches_directory]}"
  action :run
  not_if { save_directories }
end

directory node[:cassandra][:saved_caches_directory] do
  owner "cassandra"
  group "cassandra"
  mode "0700"
  recursive true
  action :create
end

directory File.dirname(node[:cassandra][:log4j_file_log]) do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

# Start the cassandra server process.
service "cassandra" do
  action :start
end

#######################################################################
# End of recipe transactions
#######################################################################
Chef::Log.info("Cassandra: End cassandra:server") if debug
