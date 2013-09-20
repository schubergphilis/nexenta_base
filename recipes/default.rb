#
# Cookbook Name:: nexenta_base
# Recipe:: default
#
# Copyright 2013, Schuberg Philis
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


# Create a class to compare version numbers
# Gem::Version could be used as well, but depends on ruby and chef version

class Version < Array
  def initialize s
    super(s.split('.').map { |e| e.to_i })
  end
  def < x
    (self <=> x) < 0
  end
  def > x
    (self <=> x) > 0
  end
  def == x
    (self <=> x) == 0
  end
end

# Get the NexentaStor version
current = %x[cat /etc/release |grep "Open Storage Appliance" |cut -d "v" -f2].chomp


## Ohai plugins

if File.directory?("/opt/chef/embedded/lib/ruby/gems/1.9.1/gems/ohai-6.18.0")
  ohai_dir = "/opt/chef/embedded/lib/ruby/gems/1.9.1/gems/ohai-6.18.0"
elsif File.directory?("/opt/chef/embedded/lib/ruby/gems/1.9.1/gems/ohai-6.16.0")
  ohai_dir = "/opt/chef/embedded/lib/ruby/gems/1.9.1/gems/ohai-6.16.0"
end

# add memory support for Solaris to Ohai
cookbook_file "#{ohai_dir}/lib/ohai/plugins/solaris2/memory.rb" do
  source "memory.rb"
  owner "admin"
  group "staff"
  mode "0655"
end

# add specific Nexenta info to Ohai
cookbook_file "#{ohai_dir}/lib/ohai/plugins/solaris2/nexenta.rb" do
  source "nexenta.rb"
  owner "admin"
  group "staff"
  mode "0655"
end


## Restart commands for those files which need them
 
execute "restart_ntp" do
  command "svcadm refresh ntp"
  action :nothing
end

execute "restart_syslog" do
  command "svcadm refresh system-log"
  action :nothing
end

execute "restart_snmp" do
  command "svcadm disable snmpd"
  command "svcadm enable snmpd"
  action :nothing
end

# nfs config needs to be reread or it will be lost after nms restart
perl "load_nfs_config" do
  code "use NZA::Common;
	&NZA::netsvc->reread_config('svc:/network/nfs/server:default');
	&NZA::netsvc->restart('svc:/network/nfs/server:default');"
  returns [0,11]
  action :nothing
end


## Generic settings

# set name service settings
cookbook_file "/etc/nsswitch.conf" do
  source "nsswitch.conf"
  owner "root"
  group "sys"
  mode "0644"
end

# add relevant dns search domains and name servers
template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  owner "root"
  group "sys"
  mode "0644"
  variables :template_file => source.to_s
end

# define which drives can be multipathed
cookbook_file "/kernel/drv/scsi_vhci.conf" do
  source "scsi_vhci.conf"
  owner "root"
  group "sys"
  mode "0644"
end

# define loghosts and levels
template "/etc/syslog.conf" do
  source "syslog.conf.erb"
  owner "root"
  group "sys"
  mode "0644"
  variables :template_file => source.to_s
  notifies :run, "execute[restart_syslog]"
end

# set time server. This setting will get lost after nms restart (and then set again by chef). Should be fixed in Nexentastor 4.0.
template "/etc/inet/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "sys"
  mode "0644"
  variables :template_file => source.to_s
  notifies :run, "execute[restart_ntp]"
end

# configure snmp for monitoring. This setting will get lost after nms restart (and then set again by chef). Should be fixed in Nexentastor 4.0.
template "/etc/snmp/snmpd.conf" do
  source "snmpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :template_file => source.to_s
  notifies :run, "execute[restart_snmp]"
end

# set nfs settings
template "/etc/default/nfs" do
  source "nfs.erb"
  owner "root"
  group "root"
  mode "0444"
  variables :template_file => source.to_s
  notifies :run, "perl[load_nfs_config]"
end


## One time settings (do not get checked/executed again unless the default attribute has manually been changed).

# add log rotation for nmv.log
ruby_block "create_nmv_log_attribute" do
  block do
    node.set[:nexenta][:logadm][:nmv_log_rotate_current] = "0"
    node.save
  end
  not_if { node[:nexenta][:logadm].attribute?("nmv_log_rotate_current") }
end

ruby_block "nmv_log_rotate" do
  block do
    file = Chef::Util::FileEdit.new("/etc/logadm.conf")
    file.insert_line_if_no_match("/var/log/nmv.log", "/var/log/nmv.log -C 2 -s #{node.default[:nexenta][:logadm][:nmv_log_rotate_default]}")
    file.write_file
    node.set[:nexenta][:logadm][:nmv_log_rotate_current] = node.default[:nexenta][:logadm][:nmv_log_rotate_default]
  end
  not_if { node[:nexenta][:logadm][:nmv_log_rotate_current].nil? ||\
           node[:nexenta][:logadm][:nmv_log_rotate_current] == node.default[:nexenta][:logadm][:nmv_log_rotate_default] }
end

# enable/disable reporters. since these sometimes 'hang' the nms for a few minutes, messing with monitoring.
ruby_block "create_reporter_attribute" do
  block do
    node.set[:nexenta][:nms][:nms_reporter_current] = "enable"
    node.save
  end
  not_if { node[:nexenta][:nms].attribute?("nms_reporter_current") }
end

ruby_block "change_nms_reporter" do
  block do
    system "nmc -c \"setup reporter #{node.default[:nexenta][:nms][:nms_reporter_default]}\" "
    node.set[:nexenta][:nms][:nms_reporter_current] = node.default[:nexenta][:nms][:nms_reporter_default]
  end
  not_if { node[:nexenta][:nms][:nms_reporter_current].nil? ||\
           node[:nexenta][:nms][:nms_reporter_current] == node.default[:nexenta][:nms][:nms_reporter_default] }
end

# set ses-check anti_flapping. Default setting of 0 is trigger happy, causing false positives. Only available in NexentaStor 3.1.4 and higher.
ruby_block "create_ses_check_attribute" do
  block do
    node.set[:nexenta][:nms][:ses_check_flapping_current] = "0"
    node.save
  end
  not_if { Version.new(current) < Version.new('3.1.4') || node[:nexenta][:nms].attribute?("ses_check_flapping_current") }
end

ruby_block "ses_check_flapping" do
  block do
    system "nmc -c \"setup trigger ses-check property ival_anti_flapping -p #{node.default[:nexenta][:nms][:ses_check_flapping_default]} -y\" "
    node.set[:nexenta][:nms][:ses_check_flapping_current] = node.default[:nexenta][:nms][:ses_check_flapping_default]
  end
  not_if { Version.new(current) < Version.new('3.1.4') || node[:nexenta][:nms][:ses_check_flapping_current].nil? ||\
           node[:nexenta][:nms][:ses_check_flapping_current] == node.default[:nexenta][:nms][:ses_check_flapping_default] }
end

# enable nfs
perl "enable_nfs" do
  code "use NZA::Common;
        &NZA::netsvc->enable('svc:/network/nfs/server:default');"
  only_if { (system 'svcs nfs/server|grep disabled') && (system 'sharemgr show -p |grep zfs|grep nfs') }
end


## Dynamically created settings

# set system settings based on version and amount of memory
# adding Version class as a helper for the template would be great, but only possible in Chef v11 or higher.
template "/etc/system" do
  source "system.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
    :version => current
  )
end

# add keys to the authorized_keys file. 
# in Chef v10 search can be funky, using a different way to get the same result. Should be changed to use the search function when using chef v11 or higher.
template "/root/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner "root"
  group "root"
  mode "0600"
  if node[:nexenta].attribute?("partners")
    hostname = node[:nexenta][:partners].split(".")[0]
    allnodes = Chef::REST.new(Chef::Config[:chef_server_url]).get_rest("nodes")
    variables(
      :partner => Chef::REST.new(Chef::Config[:chef_server_url]).get_rest("nodes/#{allnodes.select {|e| e =~ /#{hostname}/}.keys[0]}") || ""
    )
  end
end

