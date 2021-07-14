#
# Cookbook:: ceph-chef
# Spec:: default
#
# Copyright:: 2015-2021, Bloomberg Finance L.P. All rights reserved

require 'spec_helper'

describe 'ceph-chef::default' do
  include_context 'chef_server', CENTOS_7

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
