require 'spec_helper'

describe 'glance::backend::defaults::cinder' do
  shared_examples_for 'glance::backend::defaults::cinder' do

    context 'when default parameters' do
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/cinder_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_catalog_info').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_http_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_ca_certificates_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_endpoint_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_auth_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_user_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_os_region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_volume_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_enforce_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_use_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_mount_point_base').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_do_extend_attached').with_value('<SERVICE DEFAULT>')
      end
      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_catalog_info').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_http_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_ca_certificates_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_endpoint_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_auth_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_user_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_os_region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_volume_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_enforce_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_use_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_mount_point_base').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_do_extend_attached').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :cinder_api_insecure              => true,
          :cinder_ca_certificates_file      => '/etc/ssh/ca.crt',
          :cinder_catalog_info              => 'volume:cinder:internalURL',
          :cinder_endpoint_template         => 'http://srv-foo:8776/v1/%(project_id)s',
          :cinder_http_retries              => '10',
          :cinder_store_auth_address        => '127.0.0.2:8080/v3/',
          :cinder_store_project_name        => 'services',
          :cinder_store_user_name           => 'glance',
          :cinder_store_password            => 'glance',
          :cinder_store_user_domain_name    => 'Default',
          :cinder_store_project_domain_name => 'Default',
          :cinder_os_region_name            => 'RegionTwo',
          :cinder_volume_type               => 'glance-fast',
          :cinder_enforce_multipath         => true,
          :cinder_use_multipath             => true,
          :cinder_mount_point_base          => '/var/lib/glance/mnt',
          :cinder_do_extend_attached        => false,
        }
      end
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/cinder_api_insecure').with_value(true)
        is_expected.to contain_glance_api_config('backend_defaults/cinder_ca_certificates_file').with_value('/etc/ssh/ca.crt')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_catalog_info').with_value('volume:cinder:internalURL')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_endpoint_template').with_value('http://srv-foo:8776/v1/%(project_id)s')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_http_retries').with_value('10')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_auth_address').with_value('127.0.0.2:8080/v3/')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_project_name').with_value('services')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_user_name').with_value('glance')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_password').with_value('glance').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_user_domain_name').with_value('Default')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_store_project_domain_name').with_value('Default')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_os_region_name').with_value('RegionTwo')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_volume_type').with_value('glance-fast')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_enforce_multipath').with_value(true)
        is_expected.to contain_glance_api_config('backend_defaults/cinder_use_multipath').with_value(true)
        is_expected.to contain_glance_api_config('backend_defaults/cinder_mount_point_base').with_value('/var/lib/glance/mnt')
        is_expected.to contain_glance_api_config('backend_defaults/cinder_do_extend_attached').with_value(false)
      end
      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_api_insecure').with_value(true)
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_ca_certificates_file').with_value('/etc/ssh/ca.crt')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_catalog_info').with_value('volume:cinder:internalURL')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_endpoint_template').with_value('http://srv-foo:8776/v1/%(project_id)s')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_http_retries').with_value('10')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_auth_address').with_value('127.0.0.2:8080/v3/')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_project_name').with_value('services')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_user_name').with_value('glance')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_password').with_value('glance').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_user_domain_name').with_value('Default')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_store_project_domain_name').with_value('Default')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_os_region_name').with_value('RegionTwo')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_volume_type').with_value('glance-fast')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_enforce_multipath').with_value(true)
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_use_multipath').with_value(true)
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_mount_point_base').with_value('/var/lib/glance/mnt')
        is_expected.to contain_glance_cache_config('backend_defaults/cinder_do_extend_attached').with_value(false)
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

      it_behaves_like 'glance::backend::defaults::cinder'
    end
  end
end
