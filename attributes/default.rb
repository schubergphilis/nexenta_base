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

default["nexenta"]["nmv_log_rotate_default"]         = "10m" # must be in format 'XXm'
default["nexenta"]["nms_reporter_default"]           = "disable" # Must be either 'enable' or 'disable'
default["nexenta"]["ses_check_flapping_default"]     = "2" # Must be between 0 and 9

