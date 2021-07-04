require 'spec_helper'

describe 'glance::cors' do

  shared_examples_for 'glance::cors' do
    it 'configure cors default params' do
      is_expected.to contain_oslo__cors('glance_api_config').with(
        :allowed_origin    => '<SERVICE DEFAULT>',
        :allow_credentials => '<SERVICE DEFAULT>',
        :expose_headers    => '<SERVICE DEFAULT>',
        :max_age           => '<SERVICE DEFAULT>',
        :allow_methods     => '<SERVICE DEFAULT>',
        :allow_headers     => '<SERVICE DEFAULT>',
      )
    end

    context 'with specific parameters' do
      let :params do
        { :allowed_origin    => '*',
          :allow_credentials => true,
          :expose_headers    => 'Content-Language,Expires',
          :max_age           => 3600,
          :allow_methods     => 'GET,POST,PUT,DELETE,OPTIONS',
          :allow_headers     => 'Content-Type,Cache-Control',
        }
      end

      it 'configure cors params' do
        is_expected.to contain_oslo__cors('glance_api_config').with(
          :allowed_origin    => '*',
          :allow_credentials => true,
          :expose_headers    => 'Content-Language,Expires',
          :max_age           => 3600,
          :allow_methods     => 'GET,POST,PUT,DELETE,OPTIONS',
          :allow_headers     => 'Content-Type,Cache-Control',
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

      it_behaves_like 'glance::cors'
    end
  end

end
