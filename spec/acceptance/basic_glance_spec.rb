require 'spec_helper_acceptance'

describe 'glance class' do

  context 'default parameters' do
    pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      # Glance resources
      include ::glance
      include ::glance::client
      include ::glance::backend::file
      class { '::glance::db::mysql':
        # https://bugs.launchpad.net/puppet-glance/+bug/1446375
        collate  => 'utf8_general_ci',
        password => 'a_big_secret',
      }
      class { '::glance::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::glance::api':
        database_connection => 'mysql+pymysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
        verbose             => false,
        keystone_password   => 'a_big_secret',
      }
      class { '::glance::registry':
        database_connection => 'mysql+pymysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
        verbose             => false,
        keystone_password   => 'a_big_secret',
      }

      glance_image { 'test_image':
        ensure           => present,
        container_format => 'bare',
        disk_format      => 'qcow2',
        is_public        => 'yes',
        source           => 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img',
      }
    EOS

    it 'should configure the glance endpoint before the glance-api service uses it' do
      pp2 = pp + "Service['glance-api'] -> Keystone_endpoint['RegionOne/glance']"
      expect(apply_manifest(pp2, :expect_failures => true, :noop => true).stderr).to match(/Found 1 dependency cycle/i)
    end

    it 'should configure the glance user before the glance-api service uses it' do
      pp2 = pp + "Service['glance-api'] -> Keystone_user_role['glance@services']"
      expect(apply_manifest(pp2, :expect_failures => true, :noop => true).stderr).to match(/Found 1 dependency cycle/i)
    end

    it 'should configure the glance user before the glance-registry service uses it' do
      pp2 = pp + "Service['glance-registry'] -> Keystone_user_role['glance@services']"
      expect(apply_manifest(pp2, :expect_failures => true, :noop => true).stderr).to match(/Found 1 dependency cycle/i)
    end

    it 'should configure the glance-api service before using it to provision glance_images' do
      pp2 = pp + "Glance_image['test_image'] -> Service['glance-api']"
      expect(apply_manifest(pp2, :expect_failures => true, :noop => true).stderr).to match(/Found 1 dependency cycle/i)
    end

    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe 'glance images' do
      it 'should create a glance image' do
        shell('openstack --os-username glance --os-password a_big_secret --os-tenant-name services --os-auth-url http://127.0.0.1:5000/v2.0 image list') do |r|
          expect(r.stdout).to match(/test_image/)
          expect(r.stderr).to be_empty
        end
      end
    end
  end
end
