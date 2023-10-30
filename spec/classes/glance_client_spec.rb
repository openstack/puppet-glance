require 'spec_helper'

describe 'glance::client' do

  shared_examples 'glance client' do
    it { is_expected.to contain_class('glance::deps') }
    it { is_expected.to contain_class('glance::params') }
    it { is_expected.to contain_package('python-glanceclient').with(
        :name   => platform_params[:client_package_name],
        :ensure => 'present',
        :tag    => 'openstack',
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

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-glanceclient' }
        when 'RedHat'
          { :client_package_name => 'python3-glanceclient' }
        end
      end

      it_configures 'glance client'
    end
  end
end
