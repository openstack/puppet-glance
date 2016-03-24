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

  shared_examples_for 'glance_registry_config' do
    let :params do
      { :registry_config => config_hash,
        :registry_paste_ini_config => config_hash }
    end

    it 'configures arbitrary glance-registry configurations' do
      is_expected.to contain_glance_registry_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_registry_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_registry_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures arbitrary glance-registry-paste configurations' do
      is_expected.to contain_glance_registry_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_registry_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_registry_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'glance_glare_config' do
    let :params do
      { :glare_config => config_hash,
        :glare_paste_ini_config => config_hash }
    end

    it 'configures arbitrary glance-glare configurations' do
      is_expected.to contain_glance_glare_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_glare_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_glare_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures arbitrary glance-glare-paste configurations' do
      is_expected.to contain_glance_glare_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_glance_glare_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_glance_glare_paste_ini('DEFAULT/baz').with_ensure('absent')
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

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance_api_config'
      it_configures 'glance_registry_config'
      it_configures 'glance_glare_config'
      it_configures 'glance_cache_config'
    end
  end
end
