require 'spec_helper'

describe 'glance::backend::defaults::s3' do
  shared_examples_for 'glance::backend::defaults::s3' do
    context 'with defaults' do
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_access_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_secret_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_bucket').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_create_bucket_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_bucket_url_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_thread_pools').with_value('<SERVICE DEFAULT>')
      end

      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_access_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_secret_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_bucket').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_create_bucket_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_bucket_url_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_thread_pools').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding datadir' do
      let :params do
        {
          :s3_store_host                    => 'host',
          :s3_store_access_key              => 'access',
          :s3_store_secret_key              => 'secret',
          :s3_store_bucket                  => 'bucket',
          :s3_store_create_bucket_on_put    => false,
          :s3_store_bucket_url_format       => 'auto',
          :s3_store_large_object_size       => 100,
          :s3_store_large_object_chunk_size => 10,
          :s3_store_thread_pools            => 11,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_host').with_value('host')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_create_bucket_on_put').with_value(false)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_bucket_url_format').with_value('auto')
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_large_object_size').with_value(100)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_large_object_chunk_size').with_value(10)
        is_expected.to contain_glance_api_config('backend_defaults/s3_store_thread_pools').with_value(11)
      end

      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_host').with_value('host')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_create_bucket_on_put').with_value(false)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_bucket_url_format').with_value('auto')
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_large_object_size').with_value(100)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_large_object_chunk_size').with_value(10)
        is_expected.to contain_glance_cache_config('backend_defaults/s3_store_thread_pools').with_value(11)
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

      it_behaves_like 'glance::backend::defaults::s3'
    end
  end
end
