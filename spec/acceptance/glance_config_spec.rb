require 'spec_helper_acceptance'

describe 'basic glance config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Glance_api_config <||>
      File <||> -> Glance_registry_config <||>
      File <||> -> Glance_cache_config <||>
      File <||> -> Glance_glare_config <||>

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
      file { '/etc/glance/glance-glare.conf' :
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

      glance_glare_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_glare_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_glare_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_glare_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/glance/glance-api.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-registry.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-cache.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-glare.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end
  end
end
