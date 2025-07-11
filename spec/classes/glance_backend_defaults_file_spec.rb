require 'spec_helper'

describe 'glance::backend::defaults::file' do

  shared_examples_for 'glance::backend::defaults::file' do
    it 'configures glance-api.conf' do
      is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_datadir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_metadata_file').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_file_perm').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_chunk_size').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('backend_defaults/filesystem_thin_provisioning').with_value('<SERVICE DEFAULT>')
    end

    it 'configures glance-cache.conf' do
      is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_datadir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_metadata_file').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_file_perm').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_chunk_size').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_cache_config('backend_defaults/filesystem_thin_provisioning').with_value('<SERVICE DEFAULT>')
    end

    describe 'when overriding datadir' do
      let :params do
        {
          :filesystem_store_datadir       => '/var/lib/glance/images',
          :filesystem_store_metadata_file => '/var/lib/glance/metadata.json',
          :filesystem_store_file_perm     => 0,
          :filesystem_store_chunk_size    => 65536,
          :filesystem_thin_provisioning   => true,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_datadir')\
          .with_value('/var/lib/glance/images')
        is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_metadata_file')\
          .with_value('/var/lib/glance/metadata.json')
        is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_file_perm')\
          .with_value(0)
        is_expected.to contain_glance_api_config('backend_defaults/filesystem_store_chunk_size')\
          .with_value(65536)
        is_expected.to contain_glance_api_config('backend_defaults/filesystem_thin_provisioning')\
          .with_value(true)
      end

      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_datadir')\
          .with_value('/var/lib/glance/images')
        is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_metadata_file')\
          .with_value('/var/lib/glance/metadata.json')
        is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_file_perm')\
          .with_value(0)
        is_expected.to contain_glance_cache_config('backend_defaults/filesystem_store_chunk_size')\
          .with_value(65536)
        is_expected.to contain_glance_cache_config('backend_defaults/filesystem_thin_provisioning')\
          .with_value(true)
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

      it_behaves_like 'glance::backend::defaults::file'
    end
  end
end
