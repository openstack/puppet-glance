require 'spec_helper'

describe 'glance::property_protection' do
  shared_examples 'glance::property_protection' do

    context 'with defaults' do
      it 'configures the property protection parameters' do
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_file')
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_rule_format')
          .with_value('<SERVICE DEFAULT>')
      end

      it 'shoul remove the property protection config file' do
        is_expected.to contain_file('/etc/glance/property-protections.conf').with(
          :ensure => 'absent',
        )
      end
    end

    context 'with parameters (policies format)' do
      let :params do
        {
          :property_protection_rule_format => 'policies',
          :rules                           => {
            '^x_.*/create' => { 'value' => 'default' },
            '^x_.*/read'   => { 'value' => 'default' },
            '^x_.*/update' => { 'value' => 'default' },
            '^x_.*/delete' => { 'value' => 'default' },
          }
        }
      end

      it 'configures the property protection parameters' do
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_file')
          .with_value('/etc/glance/property-protections.conf')
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_rule_format')
          .with_value('policies')
      end

      it 'should configure the property protection config file' do
        is_expected.to contain_file('/etc/glance/property-protections.conf').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'glance',
          :mode    => '0640',
        )
        is_expected.to contain_glance_property_protections_config('^x_.*/create')
          .with_value('default')
        is_expected.to contain_glance_property_protections_config('^x_.*/read')
          .with_value('default')
        is_expected.to contain_glance_property_protections_config('^x_.*/update')
          .with_value('default')
        is_expected.to contain_glance_property_protections_config('^x_.*/delete')
          .with_value('default')
      end
    end

    context 'with parameters (roles format)' do
      let :params do
        {
          :property_protection_rule_format => 'roles',
          :rules                           => {
            '^x_.*/create' => { 'value' => ['admin', 'member', '_member_'] },
            '^x_.*/read'   => { 'value' => ['admin', 'member', '_member_'] },
            '^x_.*/update' => { 'value' => ['admin', 'member', '_member_'] },
            '^x_.*/delete' => { 'value' => ['admin', 'member', '_member_'] },
          }
        }
      end

      it 'configures the property protection parameters' do
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_file')
          .with_value('/etc/glance/property-protections.conf')
        is_expected.to contain_glance_api_config('DEFAULT/property_protection_rule_format')
          .with_value('roles')
      end

      it 'should configure the property protection config file' do
        is_expected.to contain_file('/etc/glance/property-protections.conf').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'glance',
          :mode    => '0640',
        )
        is_expected.to contain_glance_property_protections_config('^x_.*/create')
          .with_value('admin,member,_member_')
        is_expected.to contain_glance_property_protections_config('^x_.*/read')
          .with_value('admin,member,_member_')
        is_expected.to contain_glance_property_protections_config('^x_.*/update')
          .with_value('admin,member,_member_')
        is_expected.to contain_glance_property_protections_config('^x_.*/delete')
          .with_value('admin,member,_member_')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::property_protection'
    end
  end
end
