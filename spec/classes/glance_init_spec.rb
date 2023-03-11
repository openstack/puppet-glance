require 'spec_helper'

describe 'glance' do

  shared_examples_for 'glance' do
    it 'includes common classes' do
      is_expected.to contain_class('glance::deps')
      is_expected.to contain_class('glance::params')
      is_expected.to contain_class('openstacklib::openstackclient')
    end
  end

  shared_examples_for 'glance on RedHat' do
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) do
          { :package_ensure => package_ensure }
        end
        it { is_expected.to contain_package('glance').with(
          :ensure => package_ensure,
          :name   => 'openstack-glance',
          :tag    => ['openstack', 'glance-package']
        )}
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

      it_behaves_like 'glance'
      if facts[:os]['family'] == 'RedHat'
        it_configures "glance on #{facts[:os]['family']}"
      end
    end
  end

end
