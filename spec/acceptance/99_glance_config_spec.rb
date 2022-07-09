require 'spec_helper_acceptance'

describe 'basic glance config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Glance_api_config <||>
      File <||> -> Glance_cache_config <||>
      File <||> -> Glance_image_import_config <||>
      File <||> -> Glance_swift_config <||>
      File <||> -> Glance_api_paste_ini <||>

      file { '/etc/glance' :
        ensure => directory,
      }
      file { '/etc/glance/glance-api.conf' :
        ensure => file,
      }
      file { '/etc/glance/glance-cache.conf' :
        ensure => file,
      }
      file { '/etc/glance/glance-image-import.conf' :
        ensure => file,
      }
      file { '/etc/glance/glance-api-paste.ini' :
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

      glance_api_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
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

      glance_cache_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
      }

      glance_image_import_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_image_import_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_image_import_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_image_import_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glance_swift_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_swift_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_swift_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_swift_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glance_api_paste_ini { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      glance_api_paste_ini { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      glance_api_paste_ini { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      glance_api_paste_ini { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glance_api_paste_ini { 'DEFAULT/thisshouldexist3' :
        value             => 'foo',
        key_val_separator => ':'
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
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-cache.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-image-import.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-swift.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glance/glance-api-paste.ini') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3:foo') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end
  end
end
