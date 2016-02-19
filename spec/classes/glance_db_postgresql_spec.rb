require 'spec_helper'

describe 'glance::db::postgresql' do

  shared_examples_for 'glance::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('glance').with(
        :user     => 'glance',
        :password => 'md56c7c03b193c2c1e0667bc5bd891703db'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_configures 'glance::db::postgresql'
    end
  end
end
