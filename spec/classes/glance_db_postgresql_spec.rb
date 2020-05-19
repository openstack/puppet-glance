require 'spec_helper'

describe 'glance::db::postgresql' do

  shared_examples_for 'glance::db::postgresql' do
    let :req_params do
      { :password => 'glancepass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_openstacklib__db__postgresql('glance').with(
        :user       => 'glance',
        :password   => 'glancepass',
        :dbname     => 'glance',
        :encoding   => nil,
        :privileges => 'ALL',
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
