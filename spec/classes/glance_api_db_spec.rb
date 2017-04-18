require 'spec_helper'

describe 'glance::api::db' do

  shared_examples 'glance::api::db' do
    context 'with default parameters' do
      it { is_expected.to contain_oslo__db('glance_api_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:///var/lib/glance/glance.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://glance_api:glance@localhost/glance',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_db_max_retries => '-1',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
        }
      end

      it { is_expected.to contain_oslo__db('glance_api_config').with(
        :connection     => 'mysql+pymysql://glance_api:glance@localhost/glance',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :db_max_retries => '-1',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}
    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://glance_api:glance@localhost/glance' }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://glance_api:glance@localhost/glance', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'glance::api::db Debian' do
   context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://glance_api:glance@localhost/glance', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end
  end

  shared_examples_for 'glance::api::db RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://glance_api:glance@localhost/glance', }
      end

      it { is_expected.not_to contain_package('db_backend_package') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::api::db'
      it_configures "glance::api::db #{facts[:osfamily]}"
    end
  end

end

