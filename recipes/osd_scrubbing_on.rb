#
# Author:: Hans Chris Jones <chris.jones@lambdastack.io>
# Cookbook:: ceph
#
# Copyright:: 2017-2021, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This recipe will simply turn scrubbing on. There is another recipe that turns scrubbing off.
# NOTE: This recipe should be called after any maintenance on Ceph was performed where and
# osd_scrubbing_off was called.

execute 'ceph turn scrubbing on' do
  command <<-EOH
    ceph osd unset noscrub
    ceph osd unset nodeep-scrub
  EOH
end
