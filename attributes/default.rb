#
# Cookbook Name:: nexenta_base
# Attributes:: default
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

# NMS settings
default["nexenta"]["nms"]["ses_check_flapping_default"]     = "2" # Default = 0. Must be between 0 and 9.
default["nexenta"]["nms"]["nms_reporter_default"]           = "disable" # Default = enable. Must be either 'enable' or 'disable'.

# /etc/logadm/conf                                          # Add log rotation for nmv.log.
default["nexenta"]["logadm"]["nmv_log_rotate_default"]      = "10m" # must be in format 'XXm'.

# /etc/default/nfs                                          # NFS settings.
default["nexenta"]["nfs"]["nfsd_listen_backlog"]            = "64" # Default
default["nexenta"]["nfs"]["nfsd_protocol"]                  = "ALL" # Default
default["nexenta"]["nfs"]["nfsd_servers"]                   = "1024" # Default
default["nexenta"]["nfs"]["lockd_listen_backlog"]           = "64" # Default
default["nexenta"]["nfs"]["lockd_servers"]                  = "1024" # Default
default["nexenta"]["nfs"]["lockd_retransmit_timeout"]       = "5" # Default
default["nexenta"]["nfs"]["grace_period"]                   = "90" # Default
default["nexenta"]["nfs"]["nfs_server_versmax"]             = "3" # Default = 4
default["nexenta"]["nfs"]["nfs_client_versmax"]             = "3" # Default = 4

# /etc/inet/ntp.conf                                        # NTP server.
default["nexenta"]["ntp"]["timeservers"]                     = ["0.pool.ntp.org", "1.pool.ntp.org"]

# /etc/snmp/snmpd.conf                                      # SNMP settings.
default["nexenta"]["snmp"]["rocommunity"]                   = "public"
default["nexenta"]["snmp"]["sysDescr"]                      = "NexentaOS"
default["nexenta"]["snmp"]["sysLocation"]                   = ""
default["nexenta"]["snmp"]["sysContact"]                    = "youremail@yourcompany.com"
default["nexenta"]["snmp"]["trapsink"]                      = "localhost"
default["nexenta"]["snmp"]["linkUpDownNotifications"]       = "yes"
default["nexenta"]["snmp"]["master"]                        = "agentx"

# /etc/syslog.conf                                          # Loghosts.
default["nexenta"]["syslog"]["loghosts"]                    =["loghost1", "loghost2"] # Any number of hosts can be configured.

# /etc/resolv.conf                                          # Name resolution settings.
default["nexenta"]["resolv"]["search"]                      = "mgt.yourcompany.net prd.yourcompany.net" # Only extra search domains, space seperated. The default domain is already added.
default["nexenta"]["resolv"]["nameservers"]                 = ["10.2.3.4", "10.2.3.5"] # Any number of nameservers can be configured.

# /etc/system                                               # ZFS tunables. In effect after reboot.
default["nexenta"]["system"]["zfs_resilver_delay"]          = "2" # Default
default["nexenta"]["system"]["zfs_txg_synctime_ms"]         = "5000" #Default
default["nexenta"]["system"]["zfs_txg_timeout"]             = "10" # Default
default["nexenta"]["system"]["swapfs_minfree"]              = "1048576" # Non-Default. ARC keeps 4GB of memory free for the system. Leave empty to use defaults.
default["nexenta"]["system"]["l2arc_write_boost"]           = "83886080" # Non-Default. If ARC is not full writing to L2ARC will go faster. Leave empty to use defaults.
default["nexenta"]["system"]["nfs3_max_transfer_size"]      = "131072" # Non-Default. Changed to benefit our 10GB hypervisor environment. Leave empty to use defaults.
default["nexenta"]["system"]["nfs3_max_transfer_size_cots"] = "131072" # Non-Default. Changed to benefit our 10GB hypervisor environment. Leave empty to use defaults.

# /root/.ssh/authorized_keys                                # Public SSH keys. Partner key is also added. Any number of attributes with a SSH key can be added.
default["nexenta"]["authorized_keys"]["joe"]                = "ssh-dss AAAAB3Nza....examplekey......YAl1GZ+g== joe"
default["nexenta"]["authorized_keys"]["jane"]               = "ssh-dss AAAnN3GqO....examplekey......E7Z6HWwA= jane"
