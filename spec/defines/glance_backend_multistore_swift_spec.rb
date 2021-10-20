#
# Copyright 2019 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for glance::backend::multistore::swift
#

require 'spec_helper'

describe 'glance::backend::multistore::swift' do
  let (:title) { 'swift' }

  shared_examples_for 'glance::backend::multistore::swift' do
    let :params do
      {
        :swift_store_user => 'user',
        :swift_store_key  => 'key',
      }
    end

    let :pre_condition do
      'class { "glance::api::authtoken": password => "pass" }
       include ::glance::api'
    end

    describe 'when default parameters' do

      it { is_expected.to contain_class 'swift::client' }

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('swift/store_description').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_endpoint_type').with_value('internalURL')
        is_expected.to contain_glance_api_config('swift/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_store_config_file').with_value('/etc/glance/glance-swift.conf')
        is_expected.to contain_glance_api_config('swift/default_swift_reference').with_value('ref1')
        is_expected.to contain_glance_api_config('swift/swift_buffer_on_upload').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('swift/swift_upload_buffer_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_swift_config('ref1/key').with_value('key').with_secret(true)
        is_expected.to contain_glance_swift_config('ref1/user').with_value('user')
        is_expected.to contain_glance_swift_config('ref1/auth_version').with_value('2')
        is_expected.to contain_glance_swift_config('ref1/auth_address').with_value('http://127.0.0.1:5000/v3/')
        is_expected.to contain_glance_swift_config('ref1/user_domain_id').with_value('default')
        is_expected.to contain_glance_swift_config('ref1/project_domain_id').with_value('default')
      end
    end

    describe 'when overriding parameters' do
      let :params do
        {
          :store_description                   => 'My swift store',
          :swift_store_user                    => 'user2',
          :swift_store_key                     => 'key2',
          :swift_store_auth_version            => '1',
          :swift_store_auth_project_domain_id  => 'proj_domain',
          :swift_store_auth_user_domain_id     => 'user_domain',
          :swift_store_large_object_size       => '100',
          :swift_store_large_object_chunk_size => '50',
          :swift_store_auth_address            => '127.0.0.2:8080/v1.0/',
          :swift_store_container               => 'swift',
          :swift_store_create_container_on_put => true,
          :swift_store_endpoint_type           => 'publicURL',
          :swift_store_region                  => 'RegionTwo',
          :swift_store_config_file             => '/etc/glance/glance-swift2.conf',
          :default_swift_reference             => 'swift_creds',
          :swift_buffer_on_upload              => true,
          :swift_upload_buffer_dir             => '/var/glance/swift',
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('swift/store_description').with_value('My swift store')
        is_expected.to contain_glance_api_config('swift/swift_store_container').with_value('swift')
        is_expected.to contain_glance_api_config('swift/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glance_api_config('swift/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glance_api_config('swift/swift_store_large_object_chunk_size').with_value('50')
        is_expected.to contain_glance_api_config('swift/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glance_api_config('swift/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glance_api_config('swift/swift_store_config_file').with_value('/etc/glance/glance-swift2.conf')
        is_expected.to contain_glance_api_config('swift/default_swift_reference').with_value('swift_creds')
        is_expected.to contain_glance_api_config('swift/swift_buffer_on_upload').with_value(true)
        is_expected.to contain_glance_api_config('swift/swift_upload_buffer_dir').with_value('/var/glance/swift')
        is_expected.to contain_glance_swift_config('swift_creds/key').with_value('key2').with_secret(true)
        is_expected.to contain_glance_swift_config('swift_creds/user').with_value('user2')
        is_expected.to contain_glance_swift_config('swift_creds/auth_version').with_value('1')
        is_expected.to contain_glance_swift_config('swift_creds/auth_address').with_value('127.0.0.2:8080/v1.0/')
        is_expected.to contain_glance_swift_config('swift_creds/user_domain_id').with_value('user_domain')
        is_expected.to contain_glance_swift_config('swift_creds/project_domain_id').with_value('proj_domain')
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

      it_behaves_like 'glance::backend::multistore::swift'
    end
  end
end
