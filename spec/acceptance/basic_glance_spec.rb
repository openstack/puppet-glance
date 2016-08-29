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
      class { '::glance::keystone::glare_auth':
        password => 'a_big_secret',
      }
      class { '::glance::api::authtoken':
        password => 'a_big_secret',
      }
      class { '::glance::api':
        database_connection => 'mysql+pymysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
      }
      class { '::glance::registry::authtoken':
        password => 'a_big_secret',
      }
      class { '::glance::registry':
        database_connection => 'mysql+pymysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
      }
      class { '::glance::glare::db':
        database_connection => 'mysql+pymysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
      }
      class { '::glance::glare::authtoken':
        password => 'a_big_secret',
      }
      include ::glance::glare

      glance_image { 'test_image':
        ensure           => present,
        container_format => 'bare',
        disk_format      => 'qcow2',
        is_public        => 'yes',
        source           => 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img',
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

    describe 'glance images' do
      it 'should create a glance image with proper attributes' do
        glance_env_opts = '--os-username glance --os-password a_big_secret --os-tenant-name services --os-auth-url http://127.0.0.1:5000/v2.0'
        shell("openstack #{glance_env_opts} image list") do |r|
          expect(r.stdout).to match(/test_image/)
        end
        shell("openstack #{glance_env_opts} image show test_image --format shell") do |r|
          expect(r.stdout).to match(/visibility="public"/)
          expect(r.stdout).to match(/container_format="bare"/)
          expect(r.stdout).to match(/disk_format="qcow2"/)
          expect(r.stdout).to match(/properties="icanhaz='cheezburger'"/)
          expect(r.stdout).to match(/min_ram="64"/)
          expect(r.stdout).to match(/min_disk="1024"/)
        end
      end
    end
  end
end
