require 'spec_helper'

describe 'glance::client' do

  shared_examples 'glance client' do
    it { is_expected.to contain_class('glance::params') }
    it { is_expected.to contain_package('python-glanceclient').with(
        :name   => 'python-glanceclient',
        :ensure => 'present',
        :tag    => ['openstack'],
      )
    }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance client'
    end
  end
end
