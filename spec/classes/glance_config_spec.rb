require 'spec_helper'

describe 'glance::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'glance_api_config' do
    let :params do
      { :api_config => config_hash,
        :api_paste_ini_config => config_hash }
    end

    it { is_expected.to contain_class('glance::deps') }

    it 'configures arbitrary glance-api configurations' do
      is_expected.to contain_glance_api_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_api_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_api_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures arbitrary glance-api-paste configurations' do
      is_expected.to contain_glance_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'glance_cache_config' do
    let :params do
      { :cache_config => config_hash }
    end

    it 'configures arbitrary glance-cache configurations' do
      is_expected.to contain_glance_cache_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_cache_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_cache_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'glance_image_import_config' do
    let :params do
      { :image_import_config => config_hash }
    end

    it 'configures arbitrary glance-image-import configurations' do
      is_expected.to contain_glance_image_import_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_image_import_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_image_import_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'glance_rootwrap_config' do
    let :params do
      { :rootwrap_config => config_hash }
    end

    it 'configures arbitrary glance-rootwrap configurations' do
      is_expected.to contain_glance_rootwrap_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_rootwrap_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_rootwrap_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance_api_config'
      it_configures 'glance_cache_config'
      it_configures 'glance_image_import_config'
      it_configures 'glance_rootwrap_config'
    end
  end
end
