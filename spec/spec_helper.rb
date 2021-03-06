require 'chefspec'
require 'chefspec/berkshelf'

# rubocop:disable Style/MutableConstant
CENTOS_7 = {
  platform: 'centos',
  version: '7',
}

shared_context 'chef_server' do |platform|
  cached(:chef_run) do
    mon_node = stub_node('mon', platform) do |node|
      node.automatic['fqdn'] = 'ceph-mon.example.org'
      node.automatic['roles'] = 'search-ceph-mon'
    end
    ChefSpec::ServerRunner.new(platform) do |_node, server|
      server.create_node(mon_node)
    end.converge(described_recipe)
  end
  include_context 'common_stubs'
end

shared_context 'common_stubs' do
  before do
    stub_command('test -s /etc/yum.repos.d/ceph.repo')
    stub_command('test -s /lib/lsb/init-functions')
    stub_command('getenforce | grep \'Permissive|Disabled\'')
    stub_command('test -f /etc/ceph')
    stub_command('test -s /etc/ceph/ceph.mon.keyring')
    stub_command('test -s /etc/ceph/ceph.client.admin.keyring')
    stub_command('grep \'admin\' /etc/ceph/ceph.mon.keyring')
    stub_command('test -d /var/lib/ceph/mds/ceph-Fauxhai')
    stub_command('test -s /var/lib/ceph/mon/ceph-Fauxhai/keyring')
    stub_command('test -f /var/lib/ceph/mon/ceph-Fauxhai/done')
    stub_command('test -d /var/lib/ceph/mgr/ceph-Fauxhai')
    stub_command('test -s /var/lib/ceph/mgr/ceph-Fauxhai/keyring')
    stub_command('test -d /etc/ceph/scripts')
    stub_command('test -f /etc/ceph/scripts/ceph_journal.sh')
    stub_command('test -s /var/lib/ceph/bootstrap-osd/ceph.keyring')
  end
end
