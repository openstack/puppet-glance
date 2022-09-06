require 'spec_helper_acceptance'

describe 'glance class' do

  context 'default parameters' do
    pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::mysql
      include openstack_integration::memcached
      include openstack_integration::keystone
      include openstack_integration::glance

      glance_image { 'test_image':
        ensure           => present,
        container_format => 'bare',
        disk_format      => 'qcow2',
        is_public        => 'yes',
        source           => 'http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img',
        min_ram          => '64',
        min_disk         => '1024',
        properties       => { 'icanhaz' => 'cheezburger' },
      }
    EOS

    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(9292) do
      it { is_expected.to be_listening }
    end
  end
end
