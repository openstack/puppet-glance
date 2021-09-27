#
# Unit tests for glance::keystone::auth
#

require 'spec_helper'

describe 'glance::keystone::auth' do
  shared_examples_for 'glance::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'glance_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('glance').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'glance',
        :service_type        => 'image',
        :service_description => 'OpenStack Image Service',
        :region              => 'RegionOne',
        :auth_name           => 'glance',
        :password            => 'glance_password',
        :email               => 'glance@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:9292',
        :internal_url        => 'http://127.0.0.1:9292',
        :admin_url           => 'http://127.0.0.1:9292',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'glance_password',
          :auth_name           => 'alt_glance',
          :email               => 'alt_glance@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack Image Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_image',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('glance').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_image',
        :service_description => 'Alternative OpenStack Image Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_glance',
        :password            => 'glance_password',
        :email               => 'alt_glance@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::keystone::auth'
    end
  end
end
