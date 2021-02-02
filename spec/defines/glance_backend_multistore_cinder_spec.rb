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
# Unit tests for glance::backend::multistore::cinder
#

require 'spec_helper'

describe 'glance::backend::multistore::cinder' do
  let (:title) { 'cinder' }

  let :pre_condition do
    'class { "glance::api::authtoken": password => "pass" }'
  end

  shared_examples_for 'glance::backend::multistore::cinder' do

    context 'when default parameters' do

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('cinder/store_description').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_catalog_info').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_http_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_ca_certificates_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_endpoint_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_store_auth_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_store_project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_store_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_store_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_api_config('cinder/cinder_os_region_name').with_value('RegionOne')
        is_expected.to contain_glance_api_config('cinder/cinder_volume_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_enforce_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_use_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('cinder/cinder_mount_point_base').with_value('<SERVICE DEFAULT>')
      end
      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('cinder/store_description')
        is_expected.to contain_glance_cache_config('cinder/cinder_api_insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_catalog_info').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_http_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_ca_certificates_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_endpoint_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_auth_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_user_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_glance_cache_config('cinder/cinder_os_region_name').with_value('RegionOne')
        is_expected.to contain_glance_cache_config('cinder/cinder_volume_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_enforce_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_use_multipath').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('cinder/cinder_mount_point_base').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :store_description           => 'My cinder store',
          :cinder_api_insecure         => true,
          :cinder_ca_certificates_file => '/etc/ssh/ca.crt',
          :cinder_catalog_info         => 'volume:cinder:internalURL',
          :cinder_endpoint_template    => 'http://srv-foo:8776/v1/%(project_id)s',
          :cinder_http_retries         => '10',
          :cinder_store_auth_address   => '127.0.0.2:8080/v3/',
          :cinder_store_project_name   => 'services',
          :cinder_store_user_name      => 'glance',
          :cinder_store_password       => 'glance',
          :cinder_os_region_name       => 'RegionTwo',
          :cinder_volume_type          => 'glance-fast',
          :cinder_enforce_multipath    => true,
          :cinder_use_multipath        => true,
          :cinder_mount_point_base     => '/var/lib/glance/mnt',
        }
      end
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('cinder/store_description').with_value('My cinder store')
        is_expected.to contain_glance_api_config('cinder/cinder_api_insecure').with_value(true)
        is_expected.to contain_glance_api_config('cinder/cinder_ca_certificates_file').with_value('/etc/ssh/ca.crt')
        is_expected.to contain_glance_api_config('cinder/cinder_catalog_info').with_value('volume:cinder:internalURL')
        is_expected.to contain_glance_api_config('cinder/cinder_endpoint_template').with_value('http://srv-foo:8776/v1/%(project_id)s')
        is_expected.to contain_glance_api_config('cinder/cinder_http_retries').with_value('10')
        is_expected.to contain_glance_api_config('cinder/cinder_store_auth_address').with_value('127.0.0.2:8080/v3/')
        is_expected.to contain_glance_api_config('cinder/cinder_store_project_name').with_value('services')
        is_expected.to contain_glance_api_config('cinder/cinder_store_user_name').with_value('glance')
        is_expected.to contain_glance_api_config('cinder/cinder_store_password').with_value('glance').with_secret(true)
        is_expected.to contain_glance_api_config('cinder/cinder_os_region_name').with_value('RegionTwo')
        is_expected.to contain_glance_api_config('cinder/cinder_volume_type').with_value('glance-fast')
        is_expected.to contain_glance_api_config('cinder/cinder_enforce_multipath').with_value(true)
        is_expected.to contain_glance_api_config('cinder/cinder_use_multipath').with_value(true)
        is_expected.to contain_glance_api_config('cinder/cinder_mount_point_base').with_value('/var/lib/glance/mnt')
      end
      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('cinder/store_description')
        is_expected.to contain_glance_cache_config('cinder/cinder_api_insecure').with_value(true)
        is_expected.to contain_glance_cache_config('cinder/cinder_ca_certificates_file').with_value('/etc/ssh/ca.crt')
        is_expected.to contain_glance_cache_config('cinder/cinder_catalog_info').with_value('volume:cinder:internalURL')
        is_expected.to contain_glance_cache_config('cinder/cinder_endpoint_template').with_value('http://srv-foo:8776/v1/%(project_id)s')
        is_expected.to contain_glance_cache_config('cinder/cinder_http_retries').with_value('10')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_auth_address').with_value('127.0.0.2:8080/v3/')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_project_name').with_value('services')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_user_name').with_value('glance')
        is_expected.to contain_glance_cache_config('cinder/cinder_store_password').with_value('glance').with_secret(true)
        is_expected.to contain_glance_cache_config('cinder/cinder_os_region_name').with_value('RegionTwo')
        is_expected.to contain_glance_cache_config('cinder/cinder_volume_type').with_value('glance-fast')
        is_expected.to contain_glance_cache_config('cinder/cinder_enforce_multipath').with_value(true)
        is_expected.to contain_glance_cache_config('cinder/cinder_use_multipath').with_value(true)
        is_expected.to contain_glance_cache_config('cinder/cinder_mount_point_base').with_value('/var/lib/glance/mnt')
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

      it_behaves_like 'glance::backend::multistore::cinder'
    end
  end
end
