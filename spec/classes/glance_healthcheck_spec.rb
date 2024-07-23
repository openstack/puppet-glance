require 'spec_helper'

describe 'glance::healthcheck' do

  shared_examples_for 'glance::healthcheck' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_oslo__healthcheck('glance_api_config').with(
          :detailed                => '<SERVICE DEFAULT>',
          :backends                => '<SERVICE DEFAULT>',
          :allowed_source_ranges   => '<SERVICE DEFAULT>',
          :ignore_proxied_requests => '<SERVICE DEFAULT>',
          :disable_by_file_path    => '<SERVICE DEFAULT>',
          :disable_by_file_paths   => '<SERVICE DEFAULT>',
          :enable_by_file_paths    => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :detailed                => true,
          :backends                => ['disable_by_file'],
          :allowed_source_ranges   => ['10.0.0.0/24', '10.0.1.0/24'],
          :ignore_proxied_requests => false,
          :disable_by_file_path    => '/etc/glance/healthcheck/disabled',
          :disable_by_file_paths   => ['9292:/etc/glance/healthcheck/disabled'],
          :enable_by_file_paths    => ['/etc/glance/healthcheck/enabled'],
        }
      end

      it 'configures specified values' do
        is_expected.to contain_oslo__healthcheck('glance_api_config').with(
          :detailed                => true,
          :backends                => ['disable_by_file'],
          :allowed_source_ranges   => ['10.0.0.0/24', '10.0.1.0/24'],
          :ignore_proxied_requests => false,
          :disable_by_file_path    => '/etc/glance/healthcheck/disabled',
          :disable_by_file_paths   => ['9292:/etc/glance/healthcheck/disabled'],
          :enable_by_file_paths    => ['/etc/glance/healthcheck/enabled'],
        )
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

      it_configures 'glance::healthcheck'
    end
  end

end
