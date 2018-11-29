require 'spec_helper'

describe 'glance::registry' do
  let :pre_condition do
    "class { 'glance::registry::authtoken':
      password => 'ChangeMe',
    }"
  end

  let :default_params do
    {
      :bind_host              => '<SERVICE DEFAULT>',
      :bind_port              => '9191',
      :workers                => facts[:os_workers],
      :enabled                => true,
      :manage_service         => true,
      :purge_config           => false,
      :os_region_name         => '<SERVICE DEFAULT>',
      :ca_file                => '<SERVICE DEFAULT>',
      :cert_file              => '<SERVICE DEFAULT>',
      :key_file               => '<SERVICE DEFAULT>',
      :enable_v1_registry     => false,
    }
  end

  shared_examples_for 'glance::registry' do
    [
      {
        :bind_host              => '127.0.0.1',
        :bind_port              => '9111',
        :workers                => '5',
        :enabled                => false,
        :os_region_name         => 'RegionOne2',
      }
    ].each do |param_set|

      describe "when using default class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { is_expected.to contain_class 'glance::registry' }
        it { is_expected.to contain_class 'glance::registry::db' }

      it { is_expected.to contain_service('glance-registry').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running' : 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
      )}
      it { is_expected.to contain_service('glance-registry').that_subscribes_to('Anchor[glance::service::begin]')}
      it { is_expected.to contain_service('glance-registry').that_notifies('Anchor[glance::service::end]')}

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
           'enable_v1_registry',
          ].each do |config|
            is_expected.to contain_glance_registry_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
          if param_hash[:auth_strategy] == 'keystone'
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
          :pipeline          => 'validoptionstring',
        }
      end

      it { is_expected.to contain_glance_registry_config('paste_deploy/flavor').with_value('validoptionstring') }
    end

    describe 'with blank pipeline' do
      let :params do
        {
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
            :auth_strategy     => 'keystone',
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
      OSDefaults.get_facts({ :osfamily => 'unknown', :os => { :family => 'unknown', :release => { :major => '1'}}})
    end
    let(:params) { default_params }

    it_raises 'a Puppet::Error', /module glance only support osfamily RedHat and Debian/
  end

end
