require 'spec_helper'

describe 'glance::api' do

  let :default_params do
    {
      :debug                    => false,
      :use_stderr               => '<SERVICE DEFAULT>',
      :bind_host                => '<SERVICE DEFAULT>',
      :bind_port                => '9292',
      :registry_host            => '0.0.0.0',
      :registry_port            => '<SERVICE DEFAULT>',
      :registry_client_protocol => '<SERVICE DEFAULT>',
      :log_file                 => '/var/log/glance/api.log',
      :log_dir                  => '/var/log/glance',
      :auth_strategy            => 'keystone',
      :enabled                  => true,
      :manage_service           => true,
      :backlog                  => '<SERVICE DEFAULT>',
      :workers                  => '7',
      :keystone_password        => 'ChangeMe',
      :show_image_direct_url    => '<SERVICE DEFAULT>',
      :show_multiple_locations  => '<SERVICE DEFAULT>',
      :location_strategy        => '<SERVICE DEFAULT>',
      :purge_config             => false,
      :known_stores             => false,
      :delayed_delete           => '<SERVICE DEFAULT>',
      :scrub_time               => '<SERVICE DEFAULT>',
      :default_store            => false,
      :image_cache_dir          => '/var/lib/glance/image-cache',
      :image_cache_stall_time   => '<SERVICE DEFAULT>',
      :image_cache_max_size     => '<SERVICE DEFAULT>',
      :os_region_name           => 'RegionOne',
      :pipeline                 => 'keystone',
      :task_time_to_live        => '<SERVICE DEFAULT>',
      :task_executor            => '<SERVICE DEFAULT>',
      :task_work_dir            => '<SERVICE DEFAULT>',
      :taskflow_engine_mode     => '<SERVICE DEFAULT>',
      :taskflow_max_workers     => '<SERVICE DEFAULT>',
      :conversion_format        => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'glance::api' do

    [{:keystone_password => 'ChangeMe'},
     {
        :debug                    => true,
        :bind_host                => '127.0.0.1',
        :bind_port                => '9222',
        :registry_host            => '127.0.0.1',
        :registry_port            => '9111',
        :registry_client_protocol => 'https',
        :auth_strategy            => 'not_keystone',
        :enabled                  => false,
        :backlog                  => '4095',
        :workers                  => '5',
        :keystone_password        => 'ChangeMe',
        :show_image_direct_url    => true,
        :show_multiple_locations  => true,
        :location_strategy        => 'store_type',
        :delayed_delete           => 'true',
        :scrub_time               => '10',
        :image_cache_dir          => '/tmp/glance',
        :image_cache_stall_time   => '10',
        :image_cache_max_size     => '10737418240',
        :os_region_name           => 'RegionOne2',
        :pipeline                 => 'keystone2',
      }
    ].each do |param_set|

      describe "when #{param_set.empty? ? "using default" : "specifying"} class parameters" do

        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { is_expected.to contain_class 'glance' }
        it { is_expected.to contain_class 'glance::policy' }
        it { is_expected.to contain_class 'glance::api::logging' }
        it { is_expected.to contain_class 'glance::api::db' }

        it { is_expected.to contain_service('glance-api').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
        ) }

        it { is_expected.to_not contain_exec('validate_nova_api') }
        it { is_expected.to contain_glance_api_config("paste_deploy/flavor").with_value(param_hash[:pipeline]) }

        it 'is_expected.to lay down default api config' do
          [
            'use_stderr',
            'bind_host',
            'bind_port',
            'registry_host',
            'registry_port',
            'registry_client_protocol',
            'show_image_direct_url',
            'show_multiple_locations',
            'location_strategy',
            'delayed_delete',
            'scrub_time',
            'image_cache_dir',
          ].each do |config|
            is_expected.to contain_glance_api_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default cache config' do
          [
            'registry_host',
            'registry_port',
            'image_cache_stall_time',
            'image_cache_max_size',
          ].each do |config|
            is_expected.to contain_glance_cache_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default glance_store api and cache config' do
          [
            'os_region_name',
          ].each do |config|
            is_expected.to contain_glance_cache_config("glance_store/#{config}").with_value(param_hash[config.intern])
            is_expected.to contain_glance_api_config("glance_store/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default task & taskflow_executor config' do
          is_expected.to contain_glance_api_config('task/task_time_to_live').with_value(param_hash[:task_time_to_live])
          is_expected.to contain_glance_api_config('task/task_executor').with_value(param_hash[:task_executor])
          is_expected.to contain_glance_api_config('task/work_dir').with_value(param_hash[:task_work_dir])
          is_expected.to contain_glance_api_config('taskflow_executor/engine_mode').with_value(param_hash[:taskflow_engine_mode])
          is_expected.to contain_glance_api_config('taskflow_executor/max_workers').with_value(param_hash[:taskflow_max_workers])
          is_expected.to contain_glance_api_config('taskflow_executor/conversion_format').with_value(param_hash[:conversion_format])
        end

        it 'is_expected.to have no ssl options' do
          is_expected.to contain_glance_api_config('DEFAULT/ca_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/cert_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/key_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_ca_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_cert_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_key_file').with_value('<SERVICE DEFAULT>')
        end

        it 'passes purge to resource' do
          is_expected.to contain_resources('glance_api_config').with({
            :purge => false
          })
        end
      end

    end

    describe 'with disabled service managing' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :manage_service    => false,
          :enabled           => false,
        }
      end

      it { is_expected.to contain_service('glance-api').with(
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

      it { is_expected.to contain_glance_api_config('paste_deploy/flavor').with_value('something') }
    end

    describe 'with blank pipeline' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => '',
        }
      end

      it { is_expected.to contain_glance_api_config('paste_deploy/flavor').with_ensure('absent') }
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
            :pipeline          => pipeline
          }
        end

        it { expect { is_expected.to contain_glance_api_config('filter:paste_deploy/flavor') }.to\
          raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
      end
    end

    describe 'setting enable_proxy_headers_parsing' do
      let :params do
        default_params.merge({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_glance_api_config('oslo_middleware/enable_proxy_headers_parsing').with_value(true) }
    end

    describe 'with ssl options' do
      let :params do
        default_params.merge({
          :ca_file                   => '/tmp/ca_file',
          :cert_file                 => '/tmp/cert_file',
          :key_file                  => '/tmp/key_file',
          :registry_client_ca_file   => '/tmp/registry_ca_file',
          :registry_client_key_file  => '/tmp/registry_key_file',
          :registry_client_cert_file => '/tmp/registry_cert_file',
        })
      end

      context 'with ssl options' do
        it { is_expected.to contain_glance_api_config('DEFAULT/ca_file').with_value('/tmp/ca_file') }
        it { is_expected.to contain_glance_api_config('DEFAULT/cert_file').with_value('/tmp/cert_file') }
        it { is_expected.to contain_glance_api_config('DEFAULT/key_file').with_value('/tmp/key_file') }
        it { is_expected.to contain_glance_api_config('DEFAULT/registry_client_ca_file').with_value('/tmp/registry_ca_file') }
        it { is_expected.to contain_glance_api_config('DEFAULT/registry_client_key_file').with_value('/tmp/registry_key_file') }
        it { is_expected.to contain_glance_api_config('DEFAULT/registry_client_cert_file').with_value('/tmp/registry_cert_file') }
      end
    end

    describe 'with stores by default' do
      let :params do
        default_params
      end

      it { is_expected.to_not contain_glance_api_config('glance_store/stores').with_value('false') }
    end

    describe 'with stores override' do
      let :params do
        default_params.merge({
          :default_store => 'file',
          :stores        => ['file','http'],
          :multi_store   => true,
        })
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file,http') }
    end

    describe 'with single store override and no default store' do
      let :params do
        default_params.merge({
          :stores      => ['file'],
          :multi_store => true,
        })
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file') }
    end

    describe 'with multiple stores override and no default store' do
      let :params do
        default_params.merge({
          :stores      => ['file', 'http'],
          :multi_store => true,
        })
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file,http') }
    end

    describe 'with both stores and known_stores provided' do
      let :params do
        default_params.merge({
          :stores       => ['file'],
          :known_stores => ['glance.store.http.store'],
        })
      end

      it { is_expected.to raise_error(Puppet::Error, /known_stores and stores cannot both be assigned values/) }
    end

    describe 'with known_stores not set but with default_store' do
      let :params do
        default_params.merge({
          :default_store => 'file',
          :multi_store   => true,
        })
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file') }
    end

    describe 'with task & taskflow configuration' do
      let :params do
        default_params.merge({
          :task_time_to_live    => 72,
          :task_executor        => 'taskflow-next-gen',
          :task_work_dir        => '/tmp/large',
          :taskflow_engine_mode => 'serial',
          :taskflow_max_workers => 1,
          :conversion_format    => 'raw',
        })
      end

      it 'is_expected.to lay down default task & taskflow_executor config' do
        is_expected.to contain_glance_api_config('task/task_time_to_live').with_value(72)
        is_expected.to contain_glance_api_config('task/task_executor').with_value('taskflow-next-gen')
        is_expected.to contain_glance_api_config('task/work_dir').with_value('/tmp/large')
        is_expected.to contain_glance_api_config('taskflow_executor/engine_mode').with_value('serial')
        is_expected.to contain_glance_api_config('taskflow_executor/max_workers').with_value(1)
        is_expected.to contain_glance_api_config('taskflow_executor/conversion_format').with_value('raw')
      end
    end

    describe 'while validating the service with default command' do
      let :params do
        default_params.merge({
          :validate => true,
        })
      end
      it { is_expected.to contain_exec('execute glance-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'glance --os-auth-url http://127.0.0.1:5000 --os-project-name services --os-username glance --os-password ChangeMe image-list',
      )}

      it { is_expected.to contain_anchor('create glance-api anchor').with(
        :require => 'Exec[execute glance-api validation]',
      )}
    end

    describe 'Support IPv6' do
      let :params do
        default_params.merge({
          :registry_host => '2001::1',
        })
      end
      it { is_expected.to contain_glance_api_config('DEFAULT/registry_host').with(
        :value => '[2001::1]'
      )}
    end

    describe 'while validating the service with custom command' do
      let :params do
        default_params.merge({
          :validate            => true,
          :validation_options  => { 'glance-api' => { 'command' => 'my-script' } }
        })
      end
      it { is_expected.to contain_exec('execute glance-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'my-script',
      )}

      it { is_expected.to contain_anchor('create glance-api anchor').with(
        :require => 'Exec[execute glance-api validation]',
      )}
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
        is_expected.to contain_glance_api_config('keystone_authtoken/memcached_servers').with_value(params[:memcached_servers])
        is_expected.to contain_glance_api_config('keystone_authtoken/username').with_value(params[:keystone_user])
        is_expected.to contain_glance_api_config('keystone_authtoken/project_name').with_value(params[:keystone_tenant])
        is_expected.to contain_glance_api_config('keystone_authtoken/password').with_value(params[:keystone_password])
        is_expected.to contain_glance_api_config('keystone_authtoken/token_cache_time').with_value(params[:token_cache_time])
        is_expected.to contain_glance_api_config('keystone_authtoken/signing_dir').with_value(params[:signing_dir])
        is_expected.to contain_glance_api_config('keystone_authtoken/auth_uri').with_value(params[:auth_uri])
        is_expected.to contain_glance_api_config('keystone_authtoken/auth_url').with_value(params[:identity_uri])
      end
    end
  end

  shared_examples_for 'glance::api Debian' do
    let(:params) { default_params }

    # We only test this on Debian platforms, since on RedHat there isn't a
    # separate package for glance API.
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) { default_params.merge({ :package_ensure => package_ensure }) }
        it { is_expected.to contain_package('glance-api').with(
            :ensure => package_ensure,
            :tag    => ['openstack', 'glance-package']
        )}
      end
    end
  end

  shared_examples_for 'glance::api RedHat' do
    let(:params) { default_params }

    it { is_expected.to contain_package('openstack-glance').with(
        :tag => ['openstack', 'glance-package'],
    )}
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::api'
      it_configures "glance::api #{facts[:osfamily]}"
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
