require 'spec_helper'

describe 'glance::registry' do
  let :default_params do
    {
      :debug                  => false,
      :use_stderr             => '<SERVICE DEFAULT>',
      :bind_host              => '<SERVICE DEFAULT>',
      :bind_port              => '9191',
      :workers                => facts[:processorcount],
      :log_file               => '/var/log/glance/registry.log',
      :log_dir                => '/var/log/glance',
      :enabled                => true,
      :manage_service         => true,
      :auth_type              => 'keystone',
      :keystone_password      => 'ChangeMe',
      :purge_config           => false,
      :sync_db                => true,
      :os_region_name         => '<SERVICE DEFAULT>',
      :ca_file                => '<SERVICE DEFAULT>',
      :cert_file              => '<SERVICE DEFAULT>',
      :key_file               => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'glance::registry' do
    [
      {:keystone_password => 'ChangeMe'},
      {
        :bind_host              => '127.0.0.1',
        :bind_port              => '9111',
        :workers                => '5',
        :enabled                => false,
        :auth_type              => 'keystone',
        :keystone_password      => 'ChangeMe',
        :sync_db                => false,
        :os_region_name         => 'RegionOne2',
      }
    ].each do |param_set|

      describe "when #{param_set == {:keystone_password => 'ChangeMe'} ? "using default" : "specifying"} class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { is_expected.to contain_class 'glance::registry' }
        it { is_expected.to contain_class 'glance::registry::db' }
        it { is_expected.to contain_class 'glance::registry::logging' }

      it { is_expected.to contain_service('glance-registry').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running' : 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
      )}
      it { is_expected.to contain_service('glance-registry').that_subscribes_to('Anchor[glance::service::begin]')}
      it { is_expected.to contain_service('glance-registry').that_notifies('Anchor[glance::service::end]')}

        it 'is_expected.to not sync the db if sync_db is set to false' do

          if !param_hash[:sync_db]
            is_expected.not_to contain_exec('glance-manage db_sync')
          end
        end
        it 'passes purge to resource' do
          is_expected.to contain_resources('glance_registry_config').with({
            :purge => false
          })
        end
        it 'is_expected.to configure itself' do
          [
           'workers',
           'bind_port',
           'bind_host',
          ].each do |config|
            is_expected.to contain_glance_registry_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
          if param_hash[:auth_type] == 'keystone'
            is_expected.to contain_glance_registry_config("paste_deploy/flavor").with_value('keystone')
          end
        end
        it 'is_expected.to lay down default glance_store registry config' do
          [
            'os_region_name',
          ].each do |config|
            is_expected.to contain_glance_registry_config("glance_store/#{config}").with_value(param_hash[config.intern])
          end
        end
        it 'is_expected.to lay down default ssl config' do
          [
            'ca_file',
            'cert_file',
            'key_file',
          ].each do |config|
            is_expected.to contain_glance_registry_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
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

      it { is_expected.to contain_service('glance-registry').with(
            'ensure'     => nil,
            'enable'     => false,
            'hasstatus'  => true,
            'hasrestart' => true,
            'tag'        => 'glance-service',
        )}
      it { is_expected.to contain_service('glance-registry').that_subscribes_to('Anchor[glance::service::begin]')}
      it { is_expected.to contain_service('glance-registry').that_notifies('Anchor[glance::service::end]')}
    end

    describe 'with overridden pipeline' do
      # At the time of writing there was only blank and keystone as options
      # but there is no reason that there can't be more options in the future.
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => 'validoptionstring',
        }
      end

      it { is_expected.to contain_glance_registry_config('paste_deploy/flavor').with_value('validoptionstring') }
    end

    describe 'with blank pipeline' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => '',
        }
      end

      it { is_expected.to contain_glance_registry_config('paste_deploy/flavor').with_ensure('absent') }
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
            :auth_type         => 'keystone',
            :pipeline          => pipeline
          }
        end

        it { expect { is_expected.to contain_glance_registry_config('filter:paste_deploy/flavor') }.to\
          raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
      end
    end

    describe 'with ssl options' do
      let :params do
        default_params.merge({
          :ca_file     => '/tmp/ca_file',
          :cert_file   => '/tmp/cert_file',
          :key_file    => '/tmp/key_file'
        })
      end

      context 'with ssl options' do
        it { is_expected.to contain_glance_registry_config('DEFAULT/ca_file').with_value('/tmp/ca_file') }
        it { is_expected.to contain_glance_registry_config('DEFAULT/cert_file').with_value('/tmp/cert_file') }
        it { is_expected.to contain_glance_registry_config('DEFAULT/key_file').with_value('/tmp/key_file') }
      end
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
        is_expected.to contain_glance_registry_config('keystone_authtoken/memcached_servers').with_value(params[:memcached_servers])
        is_expected.to contain_glance_registry_config('keystone_authtoken/username').with_value(params[:keystone_user])
        is_expected.to contain_glance_registry_config('keystone_authtoken/project_name').with_value(params[:keystone_tenant])
        is_expected.to contain_glance_registry_config('keystone_authtoken/password').with_value(params[:keystone_password])
        is_expected.to contain_glance_registry_config('keystone_authtoken/token_cache_time').with_value(params[:token_cache_time])
        is_expected.to contain_glance_registry_config('keystone_authtoken/signing_dir').with_value(params[:signing_dir])
        is_expected.to contain_glance_registry_config('keystone_authtoken/auth_uri').with_value(params[:auth_uri])
        is_expected.to contain_glance_registry_config('keystone_authtoken/auth_url').with_value(params[:identity_uri])
      end
    end
  end

  shared_examples_for 'glance::registry Debian' do
    # We only test this on Debian platforms, since on RedHat there isn't a
    # separate package for glance registry.
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) { default_params.merge({ :package_ensure => package_ensure }) }
        it { is_expected.to contain_package('glance-registry').with(
            :ensure => package_ensure,
            :tag    => ['openstack', 'glance-package']
        )}
      end
    end
  end

  shared_examples_for 'glance::registry RedHat' do
    let(:params) { default_params }

    it { is_expected.to contain_package('openstack-glance') }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::registry'
      it_configures "glance::registry #{facts[:osfamily]}"
    end
  end

  describe 'on unknown platforms' do
    let :facts do
      OSDefaults.get_facts({ :osfamily => 'unknown' })
    end
    let(:params) { default_params }

    it_raises 'a Puppet::Error', /module glance only support osfamily RedHat and Debian/
  end

end
