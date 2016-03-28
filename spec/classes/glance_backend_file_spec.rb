require 'spec_helper'

describe 'glance::backend::file' do

  shared_examples_for 'glance::backend::file' do
    it 'configures glance-api.conf' do
      is_expected.to contain_glance_api_config('glance_store/default_store').with_value('file')
      is_expected.to contain_glance_api_config('glance_store/filesystem_store_datadir').with_value('/var/lib/glance/images/')
    end

    it 'configures glance-cache.conf' do
      is_expected.to contain_glance_cache_config('glance_store/filesystem_store_datadir').with_value('/var/lib/glance/images/')
    end

      it 'configures glance-glare.conf' do
        is_expected.to_not contain_glance_glare_config('glance_store/filesystem_store_datadir').with_value('/tmp/')
      end

    describe 'when overriding datadir' do
      let :params do
        {:filesystem_store_datadir => '/tmp/',
         :glare_enabled            => true,}
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/filesystem_store_datadir').with_value('/tmp/')
      end

      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('glance_store/filesystem_store_datadir').with_value('/tmp/')
      end

      it 'configures glance-glare.conf' do
        is_expected.to contain_glance_glare_config('glance_store/filesystem_store_datadir').with_value('/tmp/')
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

      it_configures 'glance::backend::file'
    end
  end
end
