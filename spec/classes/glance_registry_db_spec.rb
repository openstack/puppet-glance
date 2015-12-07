require 'spec_helper'

describe 'glance::registry::db' do

  shared_examples 'glance::registry::db' do
    context 'with default parameters' do
      it { is_expected.to contain_glance_registry_config('database/connection').with_value('sqlite:///var/lib/glance/glance.sqlite').with_secret(true) }
      it { is_expected.to contain_glance_registry_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('database/max_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('database/max_overflow').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql://glance_registry:glance@localhost/glance',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
        }
      end

      it { is_expected.to contain_glance_registry_config('database/connection').with_value('mysql://glance_registry:glance@localhost/glance').with_secret(true) }
      it { is_expected.to contain_glance_registry_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_glance_registry_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_glance_registry_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_glance_registry_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_glance_registry_config('database/max_pool_size').with_value('11') }
      it { is_expected.to contain_glance_registry_config('database/max_overflow').with_value('21') }
    end

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    it_configures 'glance::registry::db'
  end

  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'glance::registry::db'
  end

end

