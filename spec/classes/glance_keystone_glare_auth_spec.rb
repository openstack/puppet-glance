require 'spec_helper'

describe 'glance::keystone::glare_auth' do

  shared_examples_for 'glance::keystone::glare_auth' do
    describe 'with defaults' do

      let :params do
        {:password => 'pass'}
      end

      it { is_expected.to contain_keystone_user('glare').with(
        :ensure   => 'present',
        :password => 'pass'
      )}

      it { is_expected.to contain_keystone_user_role('glare@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      ) }

      it { is_expected.to contain_keystone_service('Glance Artifacts::artifact').with(
        :ensure      => 'present',
        :description => 'Glance Artifact Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/Glance Artifacts::artifact').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9494',
        :admin_url    => 'http://127.0.0.1:9494',
        :internal_url => 'http://127.0.0.1:9494'
      )}

    end

    describe 'when auth_type, password, and service_type are overridden' do

      let :params do
        {
          :auth_name    => 'glarey',
          :password     => 'password',
          :service_type => 'glarey'
        }
      end

      it { is_expected.to contain_keystone_user('glarey').with(
        :ensure   => 'present',
        :password => 'password'
      )}

      it { is_expected.to contain_keystone_user_role('glarey@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      ) }

      it { is_expected.to contain_keystone_service('Glance Artifacts::glarey').with(
        :ensure      => 'present',
        :description => 'Glance Artifact Service'
      ) }

    end

    describe 'when overriding endpoint URLs' do
      let :params do
        { :password         => 'passw0rd',
          :region            => 'RegionTwo',
          :public_url       => 'https://10.10.10.10:82/v2',
          :internal_url     => 'https://10.10.10.11:82/v2',
          :admin_url        => 'https://10.10.10.12:82/v2' }
      end

      it { is_expected.to contain_keystone_endpoint('RegionTwo/Glance Artifacts::artifact').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:82/v2',
        :internal_url => 'https://10.10.10.11:82/v2',
        :admin_url    => 'https://10.10.10.12:82/v2'
      ) }
    end

    describe 'when endpoint is not set' do

      let :params do
        {
          :configure_endpoint => false,
          :password         => 'pass',
        }
      end

      it { is_expected.to_not contain_keystone_endpoint('RegionOne/Glance Artifacts::artifact') }
    end

    describe 'when disabling user configuration' do
      let :params do
        {
          :configure_user => false,
          :password       => 'pass',
        }
      end

      it { is_expected.to_not contain_keystone_user('glare') }

      it { is_expected.to contain_keystone_user_role('glare@services') }

      it { is_expected.to contain_keystone_service('Glance Artifacts::artifact').with(
        :ensure      => 'present',
        :description => 'Glance Artifact Service'
      ) }
    end

    describe 'when disabling user and user role configuration' do
      let :params do
        {
          :configure_user      => false,
          :configure_user_role => false,
          :password            => 'pass',
        }
      end

      it { is_expected.to_not contain_keystone_user('glare') }

      it { is_expected.to_not contain_keystone_user_role('glare@services') }

      it { is_expected.to contain_keystone_service('Glance Artifacts::artifact').with(
        :ensure      => 'present',
        :description => 'Glance Artifact Service'
      ) }
    end

    describe 'when configuring glance-glare and the keystone endpoint' do
      let :pre_condition do
        "class { 'glance::glare': keystone_password => 'test' }"
      end

      let :params do
        {
          :password => 'test',
          :configure_endpoint => true
        }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/Glance Artifacts::artifact').with_notify(["Anchor[glance::service::begin]"]) }
      end

    describe 'when overriding service name' do

      let :params do
        {
          :service_name => 'glance_service',
          :password     => 'pass'
        }
      end

      it { is_expected.to contain_keystone_user('glare') }
      it { is_expected.to contain_keystone_user_role('glare@services') }
      it { is_expected.to contain_keystone_service('glance_service::artifact') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/glance_service::artifact') }

    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::keystone::glare_auth'
    end
  end
end
