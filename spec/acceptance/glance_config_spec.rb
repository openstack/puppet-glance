require 'spec_helper_acceptance'

describe 'basic glance config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Glance_api_config <||>
      File <||> -> Glance_registry_config <||>
      File <||> -> Glance_cache_config <||>

      file { '/etc/glance' :
        ensure => directory,
      }
      file { '/etc/glance/glance-api.conf' :
        ensure => file,
      }
      file { '/etc/glance/glance-registry.conf' :
        ensure => file,
      }
      file { '/etc/glance/glance-cache.conf' :
        ensure => file,
      }

      glance_api_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_api_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_api_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_api_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glance_registry_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_registry_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_registry_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_registry_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glance_cache_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_cache_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_cache_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_cache_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/glance/glance-api.conf') do
      it { should exist }
      it { should contain('thisshouldexist=foo') }
      it { should contain('thisshouldexist2=<SERVICE DEFAULT>') }

      its(:content) { should_not match /thisshouldnotexist/ }
    end

    describe file('/etc/glance/glance-registry.conf') do
      it { should exist }
      it { should contain('thisshouldexist=foo') }
      it { should contain('thisshouldexist2=<SERVICE DEFAULT>') }

      its(:content) { should_not match /thisshouldnotexist/ }
    end

    describe file('/etc/glance/glance-cache.conf') do
      it { should exist }
      it { should contain('thisshouldexist=foo') }
      it { should contain('thisshouldexist2=<SERVICE DEFAULT>') }

      its(:content) { should_not match /thisshouldnotexist/ }
    end
  end
end
