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

provides "nexenta"

nexenta Mash.new

nexenta[:ssh_key] = File.open('/root/.ssh/id_rsa.pub').read.strip

partner = `nmc -c "show network ssh-bindings" | grep root |cut -d '@' -f 2 |cut -d ' ' -f 1`.split("\n").join(",")
nexenta[:partners] = "#{partner}" if ! partner.empty?
