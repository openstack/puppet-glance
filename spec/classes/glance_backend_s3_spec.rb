require 'spec_helper'

describe 'glance::backend::s3' do
  shared_examples_for 'glance::backend::s3' do
    let :params do
      {
        :access_key => 'access',
        :secret_key => 'secret',
        :host       => 'host',
        :bucket     => 'bucket'
      }
    end

    describe 'when default parameters' do

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/default_store').with_value('s3')
        is_expected.to contain_glance_api_config('glance_store/s3_store_access_key').with_value('access')
        is_expected.to contain_glance_api_config('glance_store/s3_store_secret_key').with_value('secret')
        is_expected.to contain_glance_api_config('glance_store/s3_store_host').with_value('host')
        is_expected.to contain_glance_api_config('glance_store/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_api_config('glance_store/s3_store_bucket_url_format').with_value('subdomain')
        is_expected.to contain_glance_api_config('glance_store/s3_store_create_bucket_on_put').with_value('false')
        is_expected.to contain_glance_api_config('glance_store/s3_store_large_object_size').with_value('100')
        is_expected.to contain_glance_api_config('glance_store/s3_store_large_object_chunk_size').with_value('10')
        is_expected.to contain_glance_api_config('glance_store/s3_store_object_buffer_dir').with_value(nil)
        is_expected.to contain_glance_api_config('glance_store/s3_store_thread_pools').with_value('10')
      end
      it 'not configures glance-glare.conf' do
        is_expected.to_not contain_glance_glare_config('glance_store/default_store').with_value('s3')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_access_key').with_value('access')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_secret_key').with_value('secret')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_host').with_value('host')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_bucket').with_value('bucket')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_bucket_url_format').with_value('subdomain')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_create_bucket_on_put').with_value('false')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_large_object_size').with_value('100')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_large_object_chunk_size').with_value('10')
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_object_buffer_dir').with_value(nil)
        is_expected.to_not contain_glance_glare_config('glance_store/s3_store_thread_pools').with_value('10')
      end

    end

    describe 'when overriding parameters' do
      let :params do
        {
          :access_key               => 'access2',
          :secret_key               => 'secret2',
          :host                     => 'host2',
          :bucket                   => 'bucket2',
          :bucket_url_format        => 'path',
          :create_bucket_on_put     => true,
          :large_object_size        => 200,
          :large_object_chunk_size  => 20,
          :object_buffer_dir        => '/tmp',
          :thread_pools             => 20,
          :glare_enabled            => true,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/s3_store_access_key').with_value('access2')
        is_expected.to contain_glance_api_config('glance_store/s3_store_secret_key').with_value('secret2')
        is_expected.to contain_glance_api_config('glance_store/s3_store_host').with_value('host2')
        is_expected.to contain_glance_api_config('glance_store/s3_store_bucket').with_value('bucket2')
        is_expected.to contain_glance_api_config('glance_store/s3_store_bucket_url_format').with_value('path')
        is_expected.to contain_glance_api_config('glance_store/s3_store_create_bucket_on_put').with_value('true')
        is_expected.to contain_glance_api_config('glance_store/s3_store_large_object_size').with_value('200')
        is_expected.to contain_glance_api_config('glance_store/s3_store_large_object_chunk_size').with_value('20')
        is_expected.to contain_glance_api_config('glance_store/s3_store_object_buffer_dir').with_value('/tmp')
        is_expected.to contain_glance_api_config('glance_store/s3_store_thread_pools').with_value('20')
      end

      it 'configures glance-glare.conf' do
        is_expected.to contain_glance_glare_config('glance_store/s3_store_access_key').with_value('access2')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_secret_key').with_value('secret2')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_host').with_value('host2')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_bucket').with_value('bucket2')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_bucket_url_format').with_value('path')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_create_bucket_on_put').with_value('true')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_large_object_size').with_value('200')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_large_object_chunk_size').with_value('20')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_object_buffer_dir').with_value('/tmp')
        is_expected.to contain_glance_glare_config('glance_store/s3_store_thread_pools').with_value('20')
      end
    end

    describe 'with invalid bucket_url_format' do
      let :params do
        {
          :access_key               => 'access',
          :secret_key               => 'secret',
          :host                     => 'host',
          :bucket                   => 'bucket',
          :bucket_url_format        => 'invalid'
        }
      end

      it 'throws errors' do
        is_expected.to raise_error(Puppet::Error, /glance::backend::s3::bucket_url_format must be either "subdomain" or "path"/)
      end
    end

    describe 'with invalid large_object_chunk_size' do
      let :params do
        {
          :access_key               => 'access',
          :secret_key               => 'secret',
          :host                     => 'host',
          :bucket                   => 'bucket',
          :large_object_chunk_size  => 1
        }
      end

      it 'throws error' do
        is_expected.to raise_error(Puppet::Error, /glance::backend::s3::large_object_chunk_size must be an integer >= 5/)
      end
    end

    describe 'with non-integer large_object_chunk_size' do
      let :params do
        {
          :access_key               => 'access',
          :secret_key               => 'secret',
          :host                     => 'host',
          :bucket                   => 'bucket',
          :large_object_chunk_size  => 'string'
        }
      end

      it 'throws error' do
        is_expected.to raise_error(Puppet::Error, /glance::backend::s3::large_object_chunk_size must be an integer >= 5/)
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

      it_configures 'glance::backend::s3'
    end
  end
end
