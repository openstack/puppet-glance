require 'spec_helper'

describe 'glance::backend::swift' do
  shared_examples_for 'glance::backend::swift' do
    let :params do
      {
        :swift_store_user => 'user',
        :swift_store_key  => 'key',
      }
    end

    let :pre_condition do
      'class { "glance::api": keystone_password => "pass" }'
    end

    describe 'when default parameters' do

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/default_store').with_value('swift')
        is_expected.to contain_glance_api_config('glance_store/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/swift_store_endpoint_type').with_value('internalURL')
        is_expected.to contain_glance_api_config('glance_store/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/swift_store_config_file').with_value('/etc/glance/glance-swift.conf')
        is_expected.to contain_glance_api_config('glance_store/default_swift_reference').with_value('ref1')
        is_expected.to contain_glance_swift_config('ref1/key').with_value('key')
        is_expected.to contain_glance_swift_config('ref1/user').with_value('user')
        is_expected.to contain_glance_swift_config('ref1/auth_version').with_value('2')
        is_expected.to contain_glance_swift_config('ref1/auth_address').with_value('http://127.0.0.1:5000/v2.0/')
        is_expected.to contain_glance_swift_config('ref1/user_domain_id').with_value('default')
        is_expected.to contain_glance_swift_config('ref1/project_domain_id').with_value('default')
      end

      it 'not configures glance-glare.conf' do
        is_expected.to_not contain_glance_glare_config('glance_store/default_store').with_value('swift')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_endpoint_type').with_value('internalURL')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/swift_store_config_file').with_value('/etc/glance/glance-swift.conf')
        is_expected.to_not contain_glance_glare_config('glance_store/default_swift_reference').with_value('ref1')
      end
    end

    describe 'when overriding parameters' do
      let :params do
        {
          :swift_store_user                    => 'user2',
          :swift_store_key                     => 'key2',
          :swift_store_auth_version            => '1',
          :swift_store_auth_project_domain_id  => 'proj_domain',
          :swift_store_auth_user_domain_id     => 'user_domain',
          :swift_store_large_object_size       => '100',
          :swift_store_auth_address            => '127.0.0.2:8080/v1.0/',
          :swift_store_container               => 'swift',
          :swift_store_create_container_on_put => true,
          :swift_store_endpoint_type           => 'publicURL',
          :swift_store_region                  => 'RegionTwo',
          :default_swift_reference             => 'swift_creds',
          :glare_enabled                       => true,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/swift_store_container').with_value('swift')
        is_expected.to contain_glance_api_config('glance_store/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glance_api_config('glance_store/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glance_api_config('glance_store/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glance_api_config('glance_store/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glance_api_config('glance_store/default_swift_reference').with_value('swift_creds')
        is_expected.to contain_glance_swift_config('swift_creds/key').with_value('key2')
        is_expected.to contain_glance_swift_config('swift_creds/user').with_value('user2')
        is_expected.to contain_glance_swift_config('swift_creds/auth_version').with_value('1')
        is_expected.to contain_glance_swift_config('swift_creds/auth_address').with_value('127.0.0.2:8080/v1.0/')
        is_expected.to contain_glance_swift_config('swift_creds/user_domain_id').with_value('user_domain')
        is_expected.to contain_glance_swift_config('swift_creds/project_domain_id').with_value('proj_domain')
      end

      it 'configures glance-glare.conf' do
        is_expected.to contain_glance_glare_config('glance_store/swift_store_container').with_value('swift')
        is_expected.to contain_glance_glare_config('glance_store/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glance_glare_config('glance_store/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glance_glare_config('glance_store/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glance_glare_config('glance_store/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glance_glare_config('glance_store/default_swift_reference').with_value('swift_creds')
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

      it_configures 'glance::backend::swift'
    end
  end
end
