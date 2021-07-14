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
#

# NOTE: Create the admin user. These variables MUST exist for this to work. The default values can be found in
# the radosgw.rb attributes file. They can also be overridden in multiple places.
# Admin user MUST have caps set properly. Without full rights, no admin functions can occur via the admin restful calls.

node['ceph']['radosgw']['users'].each do |user|
  # NOTE: Keys are always generated if the user is new! We do not want to ever store user credentials.
  access_key = ceph_chef_secure_password_alphanum_upper(20)
  secret_key = ceph_chef_secure_password(40)

  if node['ceph']['pools']['radosgw']['federated_enable'] == false
    ruby_block "initialize-radosgw-user-#{user['name']}" do
      block do
        access_key = if user.attribute?('access_key') && !user['access_key'].to_s.strip.empty?
                       "#{user['access_key']}"
                     end

        secret_key = if user.attribute?('secret_key') && !user['secret_key'].to_s.strip.empty?
                       "#{user['secret_key']}"
                     end
      end
      not_if "radosgw-admin user info --uid='#{user['uid']}'"
      ignore_failure true
    end

    if user.attribute?('buckets')
      user['buckets'].each do |bucket|
        execute "create-bucket-#{bucket['name']}" do
          command "radosgw-admin2 --user #{user['uid']} --endpoint #{node['ceph']['radosgw']['default_url']} --port #{node['ceph']['radosgw']['port']} --bucket #{bucket['name']} --action create"
          ignore_failure true
        end
      end
    end
  else
    # Loop through the instances
    # NOTE: This process is very opinionated so make sure it follows what you're wanting before running it...
    node['ceph']['pools']['radosgw']['federated_zone_instances'].each do |inst|
      ruby_block "initialize-radosgw-user-#{user['name']}-#{inst['name']}" do
        block do
          access_key = if user.attribute?('access_key') && !user['access_key'].to_s.strip.empty?
                         "#{user['access_key']}"
                       end

          secret_key = if user.attribute?('secret_key') && !user['secret_key'].to_s.strip.empty?
                         "#{user['secret_key']}"
                       end
        end
        not_if "sudo radosgw-admin user info --name client.radosgw.#{inst['region']}-#{inst['name']} --uid='#{user['uid']}'"
        ignore_failure true
      end

      next unless user.attribute?('buckets')
      user['buckets'].each do |bucket|
        execute "create-bucket-#{bucket['name']}" do
          command "radosgw-admin2 --user #{user['uid']} --endpoint #{node['ceph']['radosgw']['default_url']} --port #{node['ceph']['radosgw']['port']} --bucket #{bucket['name']} -r #{inst['region']} -z #{inst['name']} --action create"
          ignore_failure true
        end
        next unless bucket['acl'] == 'public'
        execute "change-bucket-acl-#{bucket['name']}" do
          command "radosgw-admin2 --user #{user['uid']} --endpoint #{node['ceph']['radosgw']['default_url']} --port #{node['ceph']['radosgw']['port']} --bucket #{bucket['name']} -r #{inst['region']} -z #{inst['name']} --action public"
          ignore_failure true
        end
      end
    end
  end
end
