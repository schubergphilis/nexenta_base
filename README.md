Description
===========

Cookbook to manage configuration settings of NexentaStor ZFS based storage systems.

Requirements
============

Chef 0.10+

Platform
--------

* NexentaStor 3.x

Tested On:

* NexentaStor 3.1.2
* NexentaStor 3.1.3
* NexentaStor 3.1.3.5
* NexentaStor 3.1.4
* NexentaStor 3.1.4.1
* NexentaStor 3.1.4.2
* NexentaStor 3.1.5
* NexentaStor 3.1.5.1
* NexentaStor 3.1.6

With Chef clients:
* 11.2.0
* 11.6.0

Attributes
==========

Configure all settings by changing the attributes. Best practice would be to change these in Node and Environment
attributes. Alternatively the `attributes/default.rb` can be changed directly. Some settings are used based on the node's version.
Some extra information about the non-default settings:

* `default["nexenta"]["nms"]["ses_check_flapping_default"]`     - Must be a value between 0 and 9.  
  Only for NexentaStor 3.1.4 and higher. The ses-check runner occasionally gives false positives, for which
  this setting has been added. The suggested value ensures no false positives occur.
* `default["nexenta"]["nms"]["nms_reporter_default"]`           - Must be either "enable" or "disable".  
  The NMS reporter aggregates information once a week and mails this. The aggregation process can hang the NMS 
  for a few minutes, impeding monitoring. The suggested value disables the NMS reporter.

* `default["nexenta"]["logadm"]["nmv_log_rotate_default"]`      - Must be in format "XXm".  
  Log rotation for nmv.log is not implemented in 3.x. The suggested value adds the same log rotation to nmv.log
  as the default for other log files which do have log rotation.

* `default["nexenta"]["nfs"]["nfs_server_versmax"]`             - Set the max NFS server version.
  For some workloads/applications it is not recommended to use NFSv4 (VMware, Xen) or for some
  applications enabling NFSv4 does not work at all (Cloudstack).
* `default["nexenta"]["nfs"]["nfs_client_versmax"]`             - Set the max NFS client version.
  For some workloads/applications it is not recommended to use NFSv4 (VMware, Xen) or for some
  applications enabling NFSv4 does not work at all (Cloudstack).

* `default["nexenta"]["snmp"]["extends"]`                       - Add SNMP extends if needed.
  SNMP extend scripts can be added in format ["custom_cpu /etc/custom_cpu.sh", "custom_mem /etc/custom_mem.sh"].

* `default["nexenta"]["system"]["extra"]`                       - Any key/value pair can be added.
  These will then be added to /etc/system in the #Non-Defaults section. The below are suggestions/examples.
* `default["nexenta"]["system"]["extra"]["swapfs_minfree"]`     - Number of 4kb pages.
  This sets the minimum amount of memory which will always be available for the system (not used by ARC).
  Default is 1/8th of total memory, which is way to much in a high memory system. The suggested value
  results in 4GB of memory which will not be used by ARC.
* `default["nexenta"]["system"]["extra"]["l2arc_write_boost"]`  - Max bytes/s to fill the L2ARC.
  Only used when the ARC itself is not full. Ensures the L2ARC is populated fast after a failover or reboot.

* `default["nexenta"]["authorized_keys"]["joe"]`                - Joe's public SSH key for easy/secure logon.
  Add a extra attribute and key for each user.

Templates
=========

* `System.erb`          - Dynamically adds /etc/system settings based on NexentaStor version and settings
                          set in the attributes file. In effect after reboot.  
* `Authorized_keys.erb` - Adds the node's partner key (if there is a ssh-bind) and any other keys specified
                          in the attributes file.
* `Resolv.conf.erb`     - Dynamically adds the domain name and sets the domain name as first search domain
                          since NexentaStor derives the hosts FQDN from the first search domain.
                          Search domains specified in the attributes file are added after the domain name.

Usage
=====

* Install chef-client on your NexentaStor ZFS based storage system (after the initial setup has completed).  
* Configure the attributes file (and any environment attributes if necessary/used) for your environment.
* Create a role for NexentaStor systems which uses the cookbooks default recipe.  
* Add the newly created role to your NexentaStor systems.  
* After the first two chef-client runs all settings will have been set.

License and Author
==================

- Author:: Brenn Oosterbaan (<boosterbaan@schubergphilis.com>)

Copyright:: 2013 Schuberg Philis
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
    http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
