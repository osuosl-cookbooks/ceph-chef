#
# Author: Hans Chris Jones <chris.jones@lambdastack.io>
# Cookbook: ceph
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
#

ruby_block 'gen ceph-fsid-secret' do
  block do
    require 'securerandom'
    ceph_chef_save_fsid_secret(SecureRandom.uuid)
  end
  only_if { ceph_chef_fsid_secret.nil? }
end
