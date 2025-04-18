require 'spec_helper'

describe 'glance::api' do
  let :pre_condition do
    "class { 'glance::api::authtoken':
      password => 'ChangeMe',
    }"
  end

  let :default_params do
    {
      :bind_host                      => '<SERVICE DEFAULT>',
      :bind_port                      => '<SERVICE DEFAULT>',
      :auth_strategy                  => 'keystone',
      :enabled                        => true,
      :manage_service                 => true,
      :backlog                        => '<SERVICE DEFAULT>',
      :workers                        => '7',
      :show_image_direct_url          => '<SERVICE DEFAULT>',
      :show_multiple_locations        => '<SERVICE DEFAULT>',
      :filesystem_store_metadata_file => '<SERVICE DEFAULT>',
      :filesystem_store_file_perm     => '<SERVICE DEFAULT>',
      :purge_config                   => false,
      :delayed_delete                 => '<SERVICE DEFAULT>',
      :enforce_secure_rbac            => '<SERVICE DEFAULT>',
      :use_keystone_limits            => '<SERVICE DEFAULT>',
      :image_cache_driver             => '<SERVICE DEFAULT>',
      :image_cache_dir                => '/var/lib/glance/image-cache',
      :image_cache_stall_time         => '<SERVICE DEFAULT>',
      :image_cache_max_size           => '<SERVICE DEFAULT>',
      :image_import_plugins           => '<SERVICE DEFAULT>',
      :image_conversion_output_format => '<SERVICE DEFAULT>',
      :inject_metadata_properties     => '<SERVICE DEFAULT>',
      :ignore_user_roles              => '<SERVICE DEFAULT>',
      :enabled_import_methods         => '<SERVICE DEFAULT>',
      :node_staging_uri               => '<SERVICE DEFAULT>',
      :worker_self_reference_url      => '<SERVICE DEFAULT>',
      :image_member_quota             => '<SERVICE DEFAULT>',
      :image_property_quota           => '<SERVICE DEFAULT>',
      :image_tag_quota                => '<SERVICE DEFAULT>',
      :image_location_quota           => '<SERVICE DEFAULT>',
      :image_size_cap                 => '<SERVICE DEFAULT>',
      :user_storage_quota             => '<SERVICE DEFAULT>',
      :paste_deploy_flavor            => 'keystone',
      :paste_deploy_config_file       => '<SERVICE DEFAULT>',
      :task_time_to_live              => '<SERVICE DEFAULT>',
      :task_executor                  => '<SERVICE DEFAULT>',
      :task_work_dir                  => '<SERVICE DEFAULT>',
      :taskflow_engine_mode           => '<SERVICE DEFAULT>',
      :taskflow_max_workers           => '<SERVICE DEFAULT>',
      :conversion_format              => '<SERVICE DEFAULT>',
      :sync_db                        => true,
      :limit_param_default            => '<SERVICE DEFAULT>',
      :api_limit_max                  => '<SERVICE DEFAULT>',
      :public_endpoint                => '<SERVICE DEFAULT>',
      :hashing_algorithm              => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'glance::api' do

    [{
        :bind_host                      => '127.0.0.1',
        :bind_port                      => '9222',
        :auth_strategy                  => 'not_keystone',
        :enabled                        => false,
        :backlog                        => '4095',
        :workers                        => '5',
        :show_image_direct_url          => true,
        :show_multiple_locations        => true,
        :filesystem_store_metadata_file => '/etc/glance/glance-metadata-file.conf',
        :filesystem_store_file_perm     => '0644',
        :delayed_delete                 => 'true',
        :enforce_secure_rbac            => 'true',
        :use_keystone_limits            => 'true',
        :image_cache_driver             => 'centralized_db',
        :image_cache_dir                => '/tmp/glance',
        :image_cache_stall_time         => '10',
        :image_cache_max_size           => '10737418240',
        :image_import_plugins           => 'image_conversion',
        :image_conversion_output_format => 'raw',
        :inject_metadata_properties     => 'key:val',
        :ignore_user_roles              => 'admin',
        :enabled_import_methods         => 'glance-direct,web-download',
        :node_staging_uri               => '/tmp/staging',
        :worker_self_reference_url      => 'http://worker1',
        :image_member_quota             => 128,
        :image_property_quota           => 129,
        :image_tag_quota                => 130,
        :image_location_quota           => 10,
        :image_size_cap                 => 1099511627776,
        :user_storage_quota             => 0,
        :paste_deploy_flavor            => 'keystone+caching',
        :paste_deploy_config_file       => 'glance-api-paste.ini',
        :sync_db                        => false,
        :limit_param_default            => '10',
        :api_limit_max                  => '10',
        :public_endpoint                => 'https://cloud.acme.org/api/image',
        :hashing_algorithm              => 'sha512',
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
        it { is_expected.to contain_class 'glance::api::db' }

        it 'is_expected.to not sync the db if sync_db is set to false' do

          if !param_hash[:sync_db]
            is_expected.not_to contain_exec('glance-manage db_sync')
          end
        end

        it { is_expected.to contain_service('glance-api').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'glance-service',
        ) }

        it { is_expected.to contain_glance_api_config('paste_deploy/flavor').with_value(param_hash[:paste_deploy_flavor]) }
        it { is_expected.to contain_glance_api_config('paste_deploy/config_file').with_value(param_hash[:paste_deploy_config_file]) }

        it 'is_expected.to lay down default api config' do
          [
            'bind_host',
            'bind_port',
            'show_image_direct_url',
            'show_multiple_locations',
            'delayed_delete',
            'enforce_secure_rbac',
            'use_keystone_limits',
            'image_cache_driver',
            'image_cache_dir',
            'image_cache_stall_time',
            'image_cache_max_size',
            'node_staging_uri',
            'worker_self_reference_url',
            'image_member_quota',
            'image_property_quota',
            'image_tag_quota',
            'image_location_quota',
            'image_size_cap',
            'user_storage_quota',
            'limit_param_default',
            'api_limit_max',
            'public_endpoint',
            'hashing_algorithm',
          ].each do |config|
            is_expected.to contain_glance_api_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default enabled_import_methods config' do
          # Verify brackets "[]" are added to satisfy the ListOpt syntax.
          is_expected.to contain_glance_api_config("DEFAULT/enabled_import_methods").with_value(
                           "[%s]" % param_hash[:enabled_import_methods])
        end

        it 'is_expected.to lay down default image_import_plugins config' do
          # Verify brackets "[]" are added to satisfy the ListOpt syntax.
          is_expected.to contain_glance_image_import_config("image_import_opts/image_import_plugins").with_value(
                           "[%s]" % param_hash[:image_import_plugins])
        end


        it 'is_expected.to lay down default image_conversion & inject_metadata image_import config' do
          is_expected.to contain_glance_image_import_config("image_conversion/output_format").with_value(param_hash[:image_conversion_output_format])
          is_expected.to contain_glance_image_import_config("inject_metadata_properties/inject").with_value(param_hash[:inject_metadata_properties])
          is_expected.to contain_glance_image_import_config("inject_metadata_properties/ignore_user_roles").with_value(param_hash[:ignore_user_roles])
        end

        it 'is_expected.to lay down default cache config' do
          [
            'image_cache_driver',
            'image_cache_dir',
            'image_cache_stall_time',
            'image_cache_max_size',
          ].each do |config|
            is_expected.to contain_glance_cache_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'is_expected.to lay down default glance_store api config' do
          [
            'filesystem_store_metadata_file',
            'filesystem_store_file_perm',
          ].each do |config|
            is_expected.to contain_glance_api_config("glance_store/#{config}").with_value(param_hash[config.intern])
            is_expected.to contain_glance_cache_config("glance_store/#{config}").with_value(param_hash[config.intern])
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

        it 'is_expected.to have no formats set' do
          is_expected.to contain_glance_api_config('image_format/container_formats').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('image_format/disk_formats').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_glance_api_config('image_format/require_image_format_match').with_value('<SERVICE DEFAULT>')
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
          :manage_service => false,
          :enabled        => false,
        }
      end

      it { is_expected.to_not contain_service('glance-api') }
    end

    describe 'with overridden flavor' do
      let :params do
        {
          :paste_deploy_flavor => 'something',
        }
      end

      it { is_expected.to contain_glance_api_config('paste_deploy/flavor').with_value('something') }
    end

    context 'when running glance-api in wsgi' do
      let :params do
        {
          :service_name => 'httpd'
        }
      end

      let :pre_condition do
        "include apache
         class { 'glance': }
         class { 'glance::api::authtoken':
           password => 'foo',
         }"
      end

      it 'configures glance-api service with Apache' do
        is_expected.to contain_class('apache::params')
        is_expected.to contain_service('glance-api').with(
          :ensure => 'stopped',
          :enable => false,
          :tag    => ['glance-service'],
        )
      end
    end

    context 'when service_name is not valid' do
      let :params do
        {
          :service_name => 'foobar'
        }
      end

      let :pre_condition do
        "include apache
         class { 'glance': }
         class { 'glance::api::authtoken':
           password => 'foo',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

    describe 'with platform default oslo concurrency lock_path' do
      it { is_expected.to contain_oslo__concurrency('glance_api_config').with(
        :lock_path => platform_params[:lock_path]
      )}
      it { is_expected.to contain_oslo__concurrency('glance_cache_config').with(
        :lock_path => platform_params[:lock_path]
      )}
    end

    describe 'with overridden oslo concurrency lock_path' do
      let :params do
        {:lock_path => '/glance/lock/path' }
      end

      it { is_expected.to contain_oslo__concurrency('glance_api_config').with(
        :lock_path => '/glance/lock/path',
      )}
      it { is_expected.to contain_oslo__concurrency('glance_cache_config').with(
        :lock_path => '/glance/lock/path',
      )}
    end

    describe 'setting enable_proxy_headers_parsing' do
      let :params do
        {:enable_proxy_headers_parsing => true }
      end

      it { is_expected.to contain_oslo__middleware('glance_api_config').with(
        :enable_proxy_headers_parsing => true,
      )}
    end

    describe 'setting max_request_body_size' do
      let :params do
        {:max_request_body_size => '102400' }
      end

      it { is_expected.to contain_oslo__middleware('glance_api_config').with(
        :max_request_body_size => '102400',
      )}
    end

    describe 'with formats options with strings' do
      let :params do
        {
          :container_formats => 'ami,ari',
          :disk_formats      => 'raw,iso',
        }
      end

      context 'with disk_formats option' do
        it { is_expected.to contain_glance_api_config('image_format/container_formats').with_value('ami,ari') }
        it { is_expected.to contain_glance_api_config('image_format/disk_formats').with_value('raw,iso') }
      end
    end

    describe 'with formats options with arrays' do
      let :params do
        {
          :container_formats => ['ami', 'ari'],
          :disk_formats      => ['raw', 'iso'],
        }
      end

      context 'with disk_formats option' do
        it { is_expected.to contain_glance_api_config('image_format/container_formats').with_value('ami,ari') }
        it { is_expected.to contain_glance_api_config('image_format/disk_formats').with_value('raw,iso') }
      end
    end

    describe 'with require_image_format_match' do
      let :params do
        {
          :require_image_format_match => true,
        }
      end

      context 'with require_image_format_match option' do
        it { is_expected.to contain_glance_api_config('image_format/require_image_format_match').with_value(true) }
      end
    end

    describe 'with enabled_backends and stores by default' do
      it { is_expected.to_not contain_glance_api_config('DEFAULT/enabled_backends').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to_not contain_glance_api_config('glance_store/stores').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to_not contain_glance_cache_config('DEFAULT/enabled_backends').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to_not contain_glance_cache_config('glance_store/stores').with_value('<SERVICE DEFAULT>') }
    end

    describe 'with enabled_backends' do
      let :params do
        {
          :enabled_backends => ['file1:file','http1:http'],
          :default_backend  => 'file1',
          :stores           => ['file','http'],
          :default_store    => 'file',
        }
      end

      it { is_expected.to contain_glance_api_config('DEFAULT/enabled_backends').with_value('file1:file,http1:http') }
      it { is_expected.to contain_glance_api_config('glance_store/default_backend').with_value('file1') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_ensure('absent') }
      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_ensure('absent') }

      it { is_expected.to contain_glance_cache_config('DEFAULT/enabled_backends').with_value('file1:file,http1:http') }
      it { is_expected.to contain_glance_cache_config('glance_store/default_backend').with_value('file1') }
      it { is_expected.to contain_glance_cache_config('glance_store/stores').with_ensure('absent') }
      it { is_expected.to contain_glance_cache_config('glance_store/default_store').with_ensure('absent') }
    end

    describe 'with invalid backend type' do
      let :params do
        {
          :enabled_backends => ['file1:file','bad1:mybad'],
          :default_backend  => 'file',
        }
      end

      it_raises 'a Puppet::Error', / is not a valid backend type./
    end

    describe 'with enabled_backends but no default_backend' do
      let :params do
        {
          :enabled_backends => ['file1:file','http1:http'],
        }
      end

      it_raises 'a Puppet::Error', /A glance default_backend must be specified./
    end

    describe 'with duplicate backend identifiers' do
      let :params do
        {
          :enabled_backends => ['file1:file','file1:http'],
          :default_backend  => 'file1',
        }
      end

      it_raises 'a Puppet::Error', /All backend identifiers in enabled_backends must be unique./
    end

    describe 'with invalid default_backend' do
      let :params do
        {
          :enabled_backends => ['file1:file','http1:http'],
          :default_backend  => 'file2',
        }
      end

      it_raises 'a Puppet::Error', / is not a valid backend identifier./
    end

    describe 'with stores override' do
      let :params do
        {
          :default_store => 'file',
          :stores        => ['file','http'],
          :multi_store   => true,
        }
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file,http') }

      it { is_expected.to contain_glance_cache_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_cache_config('glance_store/stores').with_value('file,http') }
    end

    describe 'with single store override and no default store' do
      let :params do
        {
          :stores      => ['file'],
          :multi_store => true,
        }
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file') }

      it { is_expected.to contain_glance_cache_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_cache_config('glance_store/stores').with_value('file') }
    end

    describe 'with multiple stores override and no default store' do
      let :params do
        {
          :stores      => ['file', 'http'],
          :multi_store => true,
        }
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file,http') }

      it { is_expected.to contain_glance_cache_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_cache_config('glance_store/stores').with_value('file,http') }
    end

    describe 'with default_store' do
      let :params do
        {
          :default_store => 'file',
          :multi_store   => true,
        }
      end

      it { is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_api_config('glance_store/stores').with_value('file') }

      it { is_expected.to contain_glance_cache_config('glance_store/default_store').with_value('file') }
      it { is_expected.to contain_glance_cache_config('glance_store/stores').with_value('file') }
    end

    describe 'with task & taskflow configuration' do
      let :params do
        {
          :task_time_to_live    => 72,
          :task_executor        => 'taskflow-next-gen',
          :task_work_dir        => '/tmp/large',
          :taskflow_engine_mode => 'serial',
          :taskflow_max_workers => 1,
          :conversion_format    => 'raw',
        }
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
  end

  shared_examples_for 'glance::api on Debian' do
    # We only test this on Debian platforms, since on RedHat there isn't a
    # separate package for glance API.
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) do
          { :package_ensure => package_ensure }
        end
        it { is_expected.to contain_package('glance-api').with(
          :ensure => package_ensure,
          :name   => 'glance-api',
          :tag    => ['openstack', 'glance-package']
        )}
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :lock_path => '/var/lock/glance' }
        when 'RedHat'
          { :lock_path => '/var/lib/glance/tmp' }
        end
      end

      it_configures 'glance::api'
      if facts[:os]['family'] == 'Debian'
        it_configures "glance::api on #{facts[:os]['family']}"
      end
    end
  end
end
