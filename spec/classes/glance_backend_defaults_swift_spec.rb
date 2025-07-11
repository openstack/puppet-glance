require 'spec_helper'

describe 'glance::backend::defaults::swift' do

  shared_examples_for 'glance::backend::defaults::swift' do
    describe 'when default parameters' do

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_service_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_buffer_on_upload').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_upload_buffer_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_retry_get_count').with_value('<SERVICE DEFAULT>')
      end
      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_service_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_buffer_on_upload').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_upload_buffer_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_retry_get_count').with_value('<SERVICE DEFAULT>')
      end
    end

    describe 'when overriding parameters' do
      let :params do
        {
          :swift_store_large_object_size       => '100',
          :swift_store_large_object_chunk_size => '50',
          :swift_store_container               => 'swift',
          :swift_store_create_container_on_put => true,
          :swift_store_endpoint_type           => 'publicURL',
          :swift_store_service_type            => 'object-store',
          :swift_store_region                  => 'RegionTwo',
          :swift_buffer_on_upload              => true,
          :swift_upload_buffer_dir             => '/var/glance/swift',
          :swift_store_retry_get_count         => 3,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_container').with_value('swift')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_large_object_chunk_size').with_value('50')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_service_type').with_value('object-store')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glance_api_config('backend_defaults/swift_buffer_on_upload').with_value(true)
        is_expected.to contain_glance_api_config('backend_defaults/swift_upload_buffer_dir').with_value('/var/glance/swift')
        is_expected.to contain_glance_api_config('backend_defaults/swift_store_retry_get_count').with_value(3)
      end
      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_container').with_value('swift')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_large_object_chunk_size').with_value('50')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_service_type').with_value('object-store')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_buffer_on_upload').with_value(true)
        is_expected.to contain_glance_cache_config('backend_defaults/swift_upload_buffer_dir').with_value('/var/glance/swift')
        is_expected.to contain_glance_cache_config('backend_defaults/swift_store_retry_get_count').with_value(3)
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

      it_behaves_like 'glance::backend::defaults::swift'
    end
  end
end
