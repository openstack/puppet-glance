require 'spec_helper_acceptance'

describe 'glance class' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      case $::osfamily {
        'Debian': {
          include ::apt
          # some packages are not autoupgraded in trusty.
          # it will be fixed in liberty, but broken in kilo.
          $need_to_be_upgraded = ['python-tz', 'python-pbr']
          apt::source { 'trusty-updates-kilo':
            location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu/',
            release           => 'trusty-updates',
            required_packages => 'ubuntu-cloud-keyring',
            repos             => 'kilo/main',
            trusted_source    => true,
          } ->
          package { $need_to_be_upgraded:
            ensure  => latest,
          }
        }
        'RedHat': {
          include ::epel # Get our epel on
        }
      }
      class { '::mysql::server': }

      # Keystone resources, needed by Glance to run
      class { '::keystone::db::mysql':
        # https://bugs.launchpad.net/puppet-keystone/+bug/1446375
        collate  => 'utf8_general_ci',
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
      }

      # Glance resources
      include ::glance
      include ::glance::client
      class { '::glance::db::mysql':
        # https://bugs.launchpad.net/puppet-glance/+bug/1446375
        collate  => 'utf8_general_ci',
        password => 'a_big_secret',
      }
      class { '::glance::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::glance::api':
        database_connection => 'mysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
        verbose             => false,
        keystone_password   => 'big_secret',
      }
      class { '::glance::registry':
        database_connection => 'mysql://glance:a_big_secret@127.0.0.1/glance?charset=utf8',
        verbose             => false,
        keystone_password   => 'a_big_secret',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
