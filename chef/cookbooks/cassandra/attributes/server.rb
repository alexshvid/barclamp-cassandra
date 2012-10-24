#
# Cookbook Name: cassandra
# Attributes: server.rb
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

default[:cassandra][:initial_token] = "" 
default[:cassandra][:save_directories] = false
  
default[:cassandra][:cluster_name] = "Test Cluster"
default[:cassandra][:storage_port] = 7000
default[:cassandra][:ssl_storage_port] = 7001
default[:cassandra][:rpc_port] = 9160

default[:cassandra][:jmx_port] = 7199
default[:cassandra][:max_heap_size] = "512M"
default[:cassandra][:heap_newsize] = "64M"
default[:cassandra][:xx_directory] = "/var/log/cassandra"

default[:cassandra][:pid_file] = "/var/run/cassandra.pid"
default[:cassandra][:output_file] = "/var/log/cassandra/output.log"

default[:cassandra][:hinted_handoff_enabled] = true
default[:cassandra][:max_hint_window_in_ms] = 3600000
default[:cassandra][:hinted_handoff_throttle_delay_in_ms] = 1

default[:cassandra][:authenticator] = "org.apache.cassandra.auth.AllowAllAuthenticator"
default[:cassandra][:authority] = "org.apache.cassandra.auth.AllowAllAuthority"
default[:cassandra][:partitioner] = "org.apache.cassandra.dht.RandomPartitioner"#org.apache.cassandra.dht.RandomPartitioner, ByteOrderedPartitioner, OrderPreservingPartitioner, CollatingOPP

default[:cassandra][:data_file_directories] = "/var/lib/cassandra/data"
default[:cassandra][:commitlog_directory] = "/var/lib/cassandra/commitlog"
default[:cassandra][:saved_caches_directory] = "/var/lib/cassandra/saved_caches"

default[:cassandra][:key_cache_save_period] = 14400
default[:cassandra][:row_cache_size_in_mb] = 0
default[:cassandra][:row_cache_save_period] = 0
default[:cassandra][:row_cache_provider] = "SerializingCacheProvider" #ConcurrentLinkedHashCacheProvider, SerializingCacheProvider

default[:cassandra][:commitlog_sync] = "periodic" #batch
default[:cassandra][:commitlog_sync_batch_window_in_ms] = 50
default[:cassandra][:commitlog_sync_period_in_ms] = 10000
default[:cassandra][:commitlog_segment_size_in_mb] = 32

default[:cassandra][:seed_provider_class_name] = "org.apache.cassandra.locator.SimpleSeedProvider"

default[:cassandra][:flush_largest_memtables_at] = 0.75
default[:cassandra][:reduce_cache_sizes_at] = 0.85
default[:cassandra][:reduce_cache_capacity_to] = 0.6

default[:cassandra][:concurrent_reads] = 32
default[:cassandra][:concurrent_writes] = 32

default[:cassandra][:memtable_flush_queue_size] = 4
default[:cassandra][:trickle_fsync] = false
default[:cassandra][:trickle_fsync_interval_in_kb] = 10240

default[:cassandra][:rpc_keepalive] = true
default[:cassandra][:rpc_server_type] = "sync" #async, hsha
default[:cassandra][:rpc_timeout_in_ms] = 10000
default[:cassandra][:rpc_min_threads] = 16
default[:cassandra][:rpc_max_threads] = 2048
default[:cassandra][:thrift_framed_transport_size_in_mb] = 15
default[:cassandra][:thrift_max_message_length_in_mb] = 16

default[:cassandra][:incremental_backups] = false
default[:cassandra][:snapshot_before_compaction] = false
default[:cassandra][:auto_snapshot] = true
default[:cassandra][:column_index_size_in_kb] = 64
default[:cassandra][:in_memory_compaction_limit_in_mb] = 64
default[:cassandra][:multithreaded_compaction] = false
default[:cassandra][:compaction_throughput_mb_per_sec] = 16
default[:cassandra][:compaction_preheat_key_cache] = true

default[:cassandra][:endpoint_snitch] = "RackInferringSnitch" # SimpleSnitch, PropertyFileSnitch, GossipingPropertyFileSnitch, RackInferringSnitch, Ec2Snitch, Ec2MultiRegionSnitch
default[:cassandra][:dynamic_snitch_update_interval_in_ms] = 100
default[:cassandra][:dynamic_snitch_reset_interval_in_ms] = 600000
default[:cassandra][:dynamic_snitch_badness_threshold] = 0.1

default[:cassandra][:request_scheduler] = "org.apache.cassandra.scheduler.NoScheduler" #org.apache.cassandra.scheduler.RoundRobinScheduler
default[:cassandra][:index_interval] = 128

default[:cassandra][:log4j_level] = "INFO"
default[:cassandra][:log4j_file_log] = "/var/log/cassandra/system.log"
default[:cassandra][:log4j_file_maxsize_in_mb] = 20
default[:cassandra][:log4j_file_maxindex] = 50

