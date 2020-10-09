require 'spec_helper'

describe 'glance::db::mysql' do
  shared_examples_for 'glance::db::mysql' do
    let :pre_condition do
      'include mysql::server'
    end

    describe "with default params" do
      let :params do
        {
          :password => 'glancepass1',
        }
      end

      it { is_expected.to contain_class('glance::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('glance').with(
        :password => 'glancepass1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}

    end

    describe "overriding default params" do
      let :params do
        {
          :password => 'glancepass2',
          :dbname   => 'glancedb2',
          :charset  => 'utf8',
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('glance').with(
        :password => 'glancepass2',
        :dbname   => 'glancedb2',
        :charset  => 'utf8'
      )}

    end

    describe "overriding allowed_hosts param to array" do
      let :params do
        {
          :password      => 'glancepass2',
          :dbname        => 'glancedb2',
          :allowed_hosts => ['127.0.0.1','%']
        }
      end

    end

    describe "overriding allowed_hosts param to string" do
      let :params do
        {
          :password      => 'glancepass2',
          :dbname        => 'glancedb2',
          :allowed_hosts => '192.168.1.1'
        }
      end

    end

    describe "overriding allowed_hosts param equals to host param " do
      let :params do
        {
          :password      => 'glancepass2',
          :dbname        => 'glancedb2',
          :allowed_hosts => '127.0.0.1'
        }
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

      it_configures 'glance::db::mysql'
    end
  end
end
