require 'spec_helper'

describe 'glance::api::db' do
  shared_examples 'glance::api::db' do
    context 'with default parameters' do
      it { should contain_class('glance::deps') }

      it { should contain_oslo__db('glance_api_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:///var/lib/glance/glance.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
        :pool_timeout   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection     => 'mysql+pymysql://glance_api:glance@localhost/glance',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_db_max_retries => '-1',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
          :database_pool_timeout   => '21',
        }
      end

      it { should contain_class('glance::deps') }

      it { should contain_oslo__db('glance_api_config').with(
        :connection     => 'mysql+pymysql://glance_api:glance@localhost/glance',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :db_max_retries => '-1',
        :retry_interval => '11',
        :max_overflow   => '21',
        :pool_timeout   => '21',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::api::db'
    end
  end
end
