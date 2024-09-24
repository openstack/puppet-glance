require 'spec_helper'

describe 'glance::os_brick' do

  shared_examples 'glance::os_brick' do

    context 'with defaults' do
      it 'configures the default values' do
        is_expected.to contain_oslo__os_brick('glance_api_config').with(
          :lock_path => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__os_brick('glance_cache_config').with(
          :lock_path => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :lock_path => '/var/lib/openstack/lock'
        }
      end

      it 'configures the overridden values' do
        is_expected.to contain_oslo__os_brick('glance_api_config').with(
          :lock_path => '/var/lib/openstack/lock',
        )
        is_expected.to contain_oslo__os_brick('glance_cache_config').with(
          :lock_path => '/var/lib/openstack/lock',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      include_examples 'glance::os_brick'
    end
  end
end
