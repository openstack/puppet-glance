require 'spec_helper'

describe 'glance::api' do

  let :default_params do
    {
      :verbose                  => false,
      :debug                    => false,
      :use_stderr               => true,
      :bind_host                => '0.0.0.0',
      :bind_port                => '9292',
      :registry_host            => '0.0.0.0',
      :registry_port            => '9191',
      :registry_client_protocol => 'http',
      :log_file                 => '/var/log/glance/api.log',
      :log_dir                  => '/var/log/glance',
      :auth_type                => 'keystone',
      :auth_region              => '<SERVICE DEFAULT>',
      :enabled                  => true,
      :manage_service           => true,
      :backlog                  => '4096',
      :workers                  => '7',
      :keystone_tenant          => 'services',
      :keystone_user            => 'glance',
      :keystone_password        => 'ChangeMe',
      :token_cache_time         => '<SERVICE DEFAULT>',
      :memcached_servers        => '<SERVICE DEFAULT>',
      :show_image_direct_url    => false,
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
      :signing_dir              => '<SERVICE DEFAULT>',
      :pipeline                 => 'keystone',
      :auth_uri                 => 'http://127.0.0.1:5000/',
      :identity_uri             => 'http://127.0.0.1:35357/',
    }
  end

  shared_examples_for 'glance::api' do
    [{:keystone_password => 'ChangeMe'},
     {
        :verbose                  => true,
        :debug                    => true,
        :bind_host                => '127.0.0.1',
        :bind_port                => '9222',
        :registry_host            => '127.0.0.1',
        :registry_port            => '9111',
        :registry_client_protocol => 'https',
        :auth_type                => 'not_keystone',
        :auth_region              => 'RegionOne2',
        :enabled                  => false,
        :backlog                  => '4095',
        :workers                  => '5',
        :keystone_tenant          => 'admin2',
        :keystone_user            => 'admin2',
        :keystone_password        => 'ChangeMe2',
        :token_cache_time         => '300',
        :show_image_direct_url    => true,
        :show_multiple_locations  => true,
        :location_strategy        => 'store_type',
        :delayed_delete           => 'true',
        :scrub_time               => '10',
        :image_cache_dir          => '/tmp/glance',
        :image_cache_stall_time   => '10',
        :image_cache_max_size     => '10737418240',
        :os_region_name           => 'RegionOne2',
        :signing_dir              => '/path/to/dir',
        :pipeline                 => 'keystone2',
        :auth_uri                 => 'http://127.0.0.1:5000/v2.0',
        :identity_uri             => 'http://127.0.0.1:35357/v2.0',
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
            'auth_region'
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

        it 'is_expected.to have no ssl options' do
          is_expected.to contain_glance_api_config('DEFAULT/ca_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/cert_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/key_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_ca_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_cert_file').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('DEFAULT/registry_client_key_file').with_value('<SERVICE DEFAULT>')
        end

        it 'is_expected.to configure itself for keystone if that is the auth_type' do
          if params[:auth_type] == 'keystone'
            is_expected.to contain('paste_deploy/flavor').with_value('keystone+cachemanagement')
            is_expected.to contain_glance_api_config('keystone_authtoken/memcached_servers').with_value(param_hash[:memcached_servers])
            ['admin_tenant_name', 'admin_user', 'admin_password', 'token_cache_time', 'signing_dir', 'auth_uri', 'identity_uri'].each do |config|
              is_expected.to contain_glance_api_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
            end
            is_expected.to contain_glance_api_config('keystone_authtoken/admin_password').with_value(param_hash[:keystone_password]).with_secret(true)

            ['admin_tenant_name', 'admin_user', 'admin_password'].each do |config|
              is_expected.to contain_glance_cache_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
            end
            is_expected.to contain_glance_cache_config('keystone_authtoken/admin_password').with_value(param_hash[:keystone_password]).with_secret(true)
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
            :keystone_password => 'ChangeMe',
            :pipeline          => pipeline
          }
        end

        it { expect { is_expected.to contain_glance_api_config('filter:paste_deploy/flavor') }.to\
          raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
      end
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
        :command     => 'glance --os-auth-url http://127.0.0.1:5000/ --os-tenant-name services --os-username glance --os-password ChangeMe image-list',
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
      { :osfamily => 'unknown' }
    end
    let(:params) { default_params }

    it_raises 'a Puppet::Error', /module glance only support osfamily RedHat and Debian/
  end

end
