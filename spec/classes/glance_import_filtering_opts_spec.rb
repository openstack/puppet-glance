require 'spec_helper'

describe 'glance::import_filtering_opts' do
  shared_examples 'glance::import_filtering_opts' do

    context 'with defaults' do
      it 'configures the import filterting options' do
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_schemes')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_schemes')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_hosts')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_hosts')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_ports')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_ports')
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :allowed_schemes    => ['http', 'https'],
          :disallowed_schemes => ['ftp', 'ftps'],
          :allowed_hosts      => ['host1', 'host2'],
          :disallowed_hosts   => ['host3', 'host4'],
          :allowed_ports      => [80, 443],
          :disallowed_ports   => [21, 990],
        }
      end

      it 'configures the import filterting options' do
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_schemes')
          .with_value('[http,https]')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_schemes')
          .with_value('[ftp,ftps]')
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_hosts')
          .with_value('[host1,host2]')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_hosts')
          .with_value('[host3,host4]')
        is_expected.to contain_glance_api_config('import_filtering_opts/allowed_ports')
          .with_value('[80,443]')
        is_expected.to contain_glance_api_config('import_filtering_opts/disallowed_ports')
          .with_value('[21,990]')
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

      it_behaves_like 'glance::import_filtering_opts'
    end
  end
end
