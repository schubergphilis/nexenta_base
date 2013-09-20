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

# /etc/logadm/conf                                                                                                                             # Add log rotation for nmv.log.
default["nexenta"]["logadm"]["nmv_log_rotate_default"]      = "10m" # must be in format 'XXm'.

# /etc/default/nfs                                                                                                                               # NFS settings.
default["nexenta"]["nfs"]["nfsd_listen_backlog"]            = "64" # Default
default["nexenta"]["nfs"]["nfsd_protocol"]                  = "ALL" # Default
default["nexenta"]["nfs"]["nfsd_servers"]                   = "1024" # Default
default["nexenta"]["nfs"]["lockd_listen_backlog"]           = "64" # Default
default["nexenta"]["nfs"]["lockd_servers"]                  = "1024" # Default
default["nexenta"]["nfs"]["lockd_retransmit_timeout"]       = "5" # Default
default["nexenta"]["nfs"]["grace_period"]                   = "90" # Default
default["nexenta"]["nfs"]["nfs_server_versmax"]             = "3" # Default = 4
default["nexenta"]["nfs"]["nfs_client_versmax"]             = "3" # Default = 4

# /etc/inet/ntp.conf                                                                                                                            # NTP server.
default["nexenta"]["ntp"]["timeserver"]                     = "ntp.pool.org"

# /etc/snmp/snmpd.conf                                                                                                                     # SNMP settings.
default["nexenta"]["snmp"]["rocommunity"]                   = "public"
default["nexenta"]["snmp"]["sysDescr"]                      = "NexentaOS"
default["nexenta"]["snmp"]["sysLocation"]                   = ""
default["nexenta"]["snmp"]["sysContact"]                    = "youremail@yourcompany.com"
default["nexenta"]["snmp"]["trapsink"]                      = "localhost"
default["nexenta"]["snmp"]["linkUpDownNotifications"]       = "yes"
default["nexenta"]["snmp"]["master"]                        = "agentx"

# /etc/syslog.conf                                                                                                                               # Loghosts.
default["nexenta"]["syslog"]["loghosts"]                    =["loghost1", "loghost2"] # Any number of hosts can be configured.

# /etc/resolv.conf                                                                                                                               # Name resolution settings.
default["nexenta"]["resolv"]["search"]                      = "mgt.yourcompany.net prd.yourcompany.net" # Only extra search domains. The default domain is already added. Any number of search domains can be configured.
default["nexenta"]["resolv"]["nameservers"]                 = ["10.2.3.4", "10.2.3.5"] # Any number of nameservers can be configured.

# /etc/system                                                                                                                                       # ZFS tunables. In effect after reboot.
default["nexenta"]["system"]["zfs_resilver_delay"]          = "2" # Default
default["nexenta"]["system"]["zfs_txg_synctime_ms"]         = "5000" #Default
default["nexenta"]["system"]["zfs_txg_timeout"]             = "10" # Default
default["nexenta"]["system"]["swapfs_minfree"]              = "1048576" # Non-Default. ARC keeps 4GB of memory free for the system. Leave empty to use defaults.
default["nexenta"]["system"]["l2arc_write_boost"]           = "83886080" # Non-Default. If ARC is not full writing to L2ARC will go faster. Leave empty to use defaults.
default["nexenta"]["system"]["nfs3_max_transfer_size"]      = "131072" # Non-Default. Changed to benefit our 10GB hypervisor environment. Leave empty to use defaults.
default["nexenta"]["system"]["nfs3_max_transfer_size_cots"] = "131072" # Non-Default. Changed to benefit our 10GB hypervisor environment. Leave empty to use defaults.

# /root/.ssh/authorized_keys                                                                                                            # Public SSH keys. Partner key is also added. Any number of attributes with a SSH key can be added.
default["nexenta"]["authorized_keys"]["joe"]                = "ssh-dss AAAAB3NzaC1kc3MAAACBAI0abRL2d3tA9Zt81RZfFlGR2i/FQFi8PFgYwmyHcpxqYycDyP9X69DCDUvItViKIWApxrOCwb49sPFQC7i6ZAtIrOItsILW7i2iY+NjlVJQAAAIAUkqFKuqE1K6ffXLQUEud1x6KsfDUKPH7Li4gCFomuPZEF8xykNKa4YMfj9C+ZfLkpqme3548qaWJx6vTIpLh+DmE41bnk/RCYKY54pZi/NUIKe0EsHYQHetIpZRoVEDMscZXrbrctdIHEtQaHmJ6pCBtRILYT6gGFH+v9OfX7GgAAAIBqb0Y1jibPE74L1Q7g+/y/0aLmMwx01R8W8lgghOM5O31MevWeri8eab677xwQq5afZ1RYy+IjPVtaTv9g9vXQ+fS2uFeDILRaWvLW+JjJsxSNG2yuBI7ohuJW+MLTSJkqhC6jFBbrqp+Rny8n/yb4Mufp5ZCm9cjR78YAl1GZ+g== joe"
default["nexenta"]["authorized_keys"]["jane"]               = "ssh-dss AAAnN3GqO89ZHSPi/1FRY1ajFGaCCDJ7MSohO5CW8FRGSEcLDR2xmOw0K6pqPdIQQXpbHLSAwKP6ydjhTou1HMH5SxKLdOVBjcIe9dJc2O/wdGpHh1zXC2S9ljeUmWrAAAAFQDW0C5kq5SNgCPs1mjBxxZe5wS3DQAAAIEAjqcJex0ijphfVKTh8RnD6n3C8490kHP7t85IOReazD4TqLlgF2jQocspxj2MzgqlK2JGnrHjux+i5lNIFHzKJiIPpx9yHuwsZLcj9ne3BnZbgj6stQYUFaapLgamX8fCkWX3dM8+Iwg/VGtEkpMw5Y2oalW2iwlzgJb/kBmjOxcAAACACk7fbZ5r++CdbkIhRhANhbTx/eUvNVsUEt9O4G7Co4NvbrbXTy+sMH9EAxfK5XAjfbGtyc/YCVLxKoiEwgaIo/f/FDTcOcKGvdFxcGf7fKuMGbqwFwmKAEsnb9kONz77CE7Z6HWwA= jane"
