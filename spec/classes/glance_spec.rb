require 'spec_helper'

describe 'glance' do

  let :default_params do
    {}
  end

  shared_examples_for 'glance' do
    describe "when using default class parameters" do
      let(:params) { default_params }

      it { is_expected.to contain_package('python-openstackclient').with(
        :tag => 'openstack'
      )}

    end
  end

  shared_examples_for 'glance Debian' do
    let(:params) { default_params }

    it { is_expected.to_not contain_package('glance') }
  end

  shared_examples_for 'glance RedHat' do
    let(:params) { default_params }

    it { is_expected.to contain_package('openstack-glance').with(
        :tag => ['openstack', 'glance-package'],
    )}
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance'
      it_configures "glance #{facts[:osfamily]}"
    end
  end
end
