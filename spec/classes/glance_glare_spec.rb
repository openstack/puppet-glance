require 'spec_helper'

describe 'glance::glare' do

  let :default_params do
    {
      :bind_host                => '0.0.0.0',
      :bind_port                => '9494',
      :auth_type                => 'keystone',
      :enabled                  => true,
      :manage_service           => true,
      :backlog                  => '4096',
      :workers                  => '7',
      :keystone_password        => 'ChangeMe',
      :stores                   => false,
      :default_store            => false,
      :os_region_name           => 'RegionOne',
      :pipeline                 => 'keystone',
    }
  end

  shared_examples_for 'glance::glare' do
    [
     {
        :bind_host                => '127.0.0.1',
        :bind_port                => '9222',
        :auth_type                => 'not_keystone',
        :enabled                  => false,
        :backlog                  => '4095',
        :workers                  => '5',
        :keystone_password        => 'ChangeMe2',
        :os_region_name           => 'RegionOne2',
        :pipeline                 => 'keystone2',
      }
    ].each do |param_set|

      describe "when #{param_set == {:keystone_password => 'ChangeMe'} ? "using default" : "specifying"} class parameters" do

        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { is_expected.to contain_class 'glance' }
        it { is_expected.to contain_class 'glance::policy' }
        it { is_expected.to contain_class 'glance::glare::logging' }
        it { is_expected.to contain_class 'glance::glare::db' }

        it { is_expected.to contain_service('glance-glare').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
        ) }

        it { is_expected.to contain_glance_glare_config("paste_deploy/flavor").with_value(param_hash[:pipeline]) }

        it 'is_expected.to lay down default glare config' do
          [
            'bind_host',
            'bind_port',
          ].each do |config|
            is_expected.to contain_glance_glare_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default glance_store glare and cache config' do
          [
            'os_region_name',
          ].each do |config|
            is_expected.to contain_glance_glare_config("glance_store/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to have no ssl options' do
          is_expected.to contain_glance_glare_config('DEFAULT/ca_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_glare_config('DEFAULT/cert_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_glare_config('DEFAULT/key_file').with_value('<SERVICE DEFAULT>')
        end

        it 'is_expected.to configure itself for keystone if that is the auth_type' do
          if params[:auth_type] == 'keystone'
            is_expected.to contain('paste_deploy/flavor').with_value('keystone+cachemanagement')
          end
        end
      end

    end

    describe 'with disabled service managing' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :manage_service => false,
          :enabled        => false,
        }
      end

      it { is_expected.to contain_service('glance-glare').with(
          'ensure'     => nil,
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
        ) }
    end

    describe 'with overridden pipeline' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => 'something',
        }
      end

      it { is_expected.to contain_glance_glare_config('paste_deploy/flavor').with_value('something') }
    end

    describe 'with blank pipeline' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => '',
        }
      end

      it { is_expected.to contain_glance_glare_config('paste_deploy/flavor').with_ensure('absent') }
    end

    [
      'keystone/',
      'keystone+',
      '+keystone',
      'keystone+cachemanagement+',
      '+'
    ].each do |pipeline|
      describe "with pipeline incorrect value #{pipeline}" do
        let :params do
          {
            :keystone_password => 'ChangeMe',
            :pipeline          => pipeline
          }
        end

        it { expect { is_expected.to contain_glance_glare_config('filter:paste_deploy/flavor') }.to\
          raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
      end
    end

    describe 'with ssl options' do
      let :params do
        default_params.merge({
          :ca_file                   => '/tmp/ca_file',
          :cert_file                 => '/tmp/cert_file',
          :key_file                  => '/tmp/key_file',
        })
      end

      context 'with ssl options' do
        it { is_expected.to contain_glance_glare_config('DEFAULT/ca_file').with_value('/tmp/ca_file') }
        it { is_expected.to contain_glance_glare_config('DEFAULT/cert_file').with_value('/tmp/cert_file') }
        it { is_expected.to contain_glance_glare_config('DEFAULT/key_file').with_value('/tmp/key_file') }
      end
    end
    describe 'with stores by default' do
      let :params do
        default_params
      end

      it { is_expected.to_not contain_glance_glare_config('glance_store/stores').with_value('false') }
    end

    describe 'with stores override' do
      let :params do
        default_params.merge({
          :default_store => 'glance.store.filesystem.Store',
          :stores        => ['glance.store.filesystem.Store','glance.store.http.Store'],
          :multi_store   => true,
        })
      end

      it { is_expected.to contain_glance_glare_config('glance_store/default_store').with_value('glance.store.filesystem.Store') }
      it { is_expected.to contain_glance_glare_config('glance_store/stores').with_value('glance.store.filesystem.Store,glance.store.http.Store') }
    end

    describe 'with single store override and no default store' do
      let :params do
        default_params.merge({
          :stores      => ['glance.store.filesystem.Store'],
          :multi_store => true,
        })
      end

      it { is_expected.to contain_glance_glare_config('glance_store/default_store').with_value('glance.store.filesystem.Store') }
      it { is_expected.to contain_glance_glare_config('glance_store/stores').with_value('glance.store.filesystem.Store') }
    end

    describe 'with multiple stores override and no default store' do
      let :params do
        default_params.merge({
          :stores      => ['glance.store.filesystem.Store', 'glance.store.http.Store'],
          :multi_store => true,
        })
      end

      it { is_expected.to contain_glance_glare_config('glance_store/default_store').with_value('glance.store.filesystem.Store') }
      it { is_expected.to contain_glance_glare_config('glance_store/stores').with_value('glance.store.filesystem.Store,glance.store.http.Store') }
    end

    describe 'with wrong format of stores provided' do
      let :params do
        default_params.merge({
          :stores => 'glance.store.filesystem.Store',
        })
      end

      it { is_expected.to raise_error(Puppet::Error, /is not an Array/) }
    end

    describe 'with known_stores not set but with default_store' do
      let :params do
        default_params.merge({
          :default_store => 'glance.store.filesystem.Store',
          :multi_store   => true,
        })
      end

      it { is_expected.to contain_glance_glare_config('glance_store/default_store').with_value('glance.store.filesystem.Store') }
      it { is_expected.to contain_glance_glare_config('glance_store/stores').with_value('glance.store.filesystem.Store') }
    end

    describe 'with deprecated auth parameters' do
      let :params do
        default_params.merge({
          :auth_type         => 'keystone',
          :keystone_tenant   => 'services',
          :keystone_user     => 'glance',
          :keystone_password => 'password',
          :token_cache_time  => '1000',
          :memcached_servers => 'localhost:11211',
          :signing_dir       => '/tmp/keystone',
          :auth_uri          => 'http://127.0.0.1:5000',
          :identity_uri      => 'http://127.0.0.1:35357',
        })
      end
      it 'deprecated auth parameters' do
        is_expected.to contain_glance_glare_config('keystone_authtoken/memcached_servers').with_value(params[:memcached_servers])
        is_expected.to contain_glance_glare_config('keystone_authtoken/username').with_value(params[:keystone_user])
        is_expected.to contain_glance_glare_config('keystone_authtoken/project_name').with_value(params[:keystone_tenant])
        is_expected.to contain_glance_glare_config('keystone_authtoken/password').with_value(params[:keystone_password])
        is_expected.to contain_glance_glare_config('keystone_authtoken/token_cache_time').with_value(params[:token_cache_time])
        is_expected.to contain_glance_glare_config('keystone_authtoken/signing_dir').with_value(params[:signing_dir])
        is_expected.to contain_glance_glare_config('keystone_authtoken/auth_uri').with_value(params[:auth_uri])
        is_expected.to contain_glance_glare_config('keystone_authtoken/auth_url').with_value(params[:identity_uri])
      end
    end
  end

  shared_examples_for 'glance::glare Debian' do
    let(:params) { default_params }

    # We only test this on Debian platforms, since on RedHat there isn't a
    # separate package for glance GLARE.
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) { default_params.merge({ :package_ensure => package_ensure }) }
        it { is_expected.to contain_package('glance-glare').with(
            :ensure => package_ensure,
            :tag    => ['openstack', 'glance-package']
        )}
      end
    end
  end

  shared_examples_for 'glance::glare RedHat' do
    let(:params) { default_params }

    it { is_expected.to contain_package('openstack-glance').with(
        :tag  => ['openstack', 'glance-package'],
    )}
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::glare'
      it_configures "glance::glare #{facts[:osfamily]}"
    end
  end

end
