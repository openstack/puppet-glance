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
# Unit tests for glance::backend::multistore::vsphere
#

require 'spec_helper'

describe 'glance::backend::multistore::vsphere' do
  let (:title) { 'vsphere' }

  let :pre_condition do
    'class { "glance::api::authtoken": password => "pass" }'
  end

  shared_examples_for 'glance::backend::multistore::vsphere' do
    let :params do
      {
        :vmware_server_host     => '10.0.0.1',
        :vmware_server_username => 'root',
        :vmware_server_password => '123456',
        :vmware_datastores      => 'Datacenter:Datastore',
        :vmware_store_image_dir => '/openstack_glance',
      }
    end

    context 'when default parameters' do
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('vsphere/store_description').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('vsphere/weight').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('vsphere/vmware_insecure').with_value('True')
        is_expected.to contain_glance_api_config('vsphere/vmware_server_host').with_value('10.0.0.1')
        is_expected.to contain_glance_api_config('vsphere/vmware_server_username').with_value('root')
        is_expected.to contain_glance_api_config('vsphere/vmware_server_password').with_value('123456').with_secret(true)
        is_expected.to contain_glance_api_config('vsphere/vmware_store_image_dir').with_value('/openstack_glance')
        is_expected.to contain_glance_api_config('vsphere/vmware_task_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('vsphere/vmware_api_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('vsphere/vmware_datastores').with_value('Datacenter:Datastore')
        is_expected.to contain_glance_api_config('vsphere/vmware_ca_file').with_value('<SERVICE DEFAULT>')
      end
      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('vsphere/store_description')
        is_expected.to contain_glance_cache_config('vsphere/weight').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('vsphere/vmware_insecure').with_value('True')
        is_expected.to contain_glance_cache_config('vsphere/vmware_server_host').with_value('10.0.0.1')
        is_expected.to contain_glance_cache_config('vsphere/vmware_server_username').with_value('root')
        is_expected.to contain_glance_cache_config('vsphere/vmware_server_password').with_value('123456').with_secret(true)
        is_expected.to contain_glance_cache_config('vsphere/vmware_store_image_dir').with_value('/openstack_glance')
        is_expected.to contain_glance_cache_config('vsphere/vmware_task_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('vsphere/vmware_api_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('vsphere/vmware_datastores').with_value('Datacenter:Datastore')
        is_expected.to contain_glance_cache_config('vsphere/vmware_ca_file').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :store_description         => 'My vsphere store',
          :weight                    => 0,
          :vmware_ca_file            => '/etc/glance/vcenter-ca.pem',
          :vmware_task_poll_interval => '6',
          :vmware_api_retry_count    => '11',
        })
      end
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('vsphere/store_description').with_value('My vsphere store')
        is_expected.to contain_glance_api_config('vsphere/weight').with_value(0)
        is_expected.to contain_glance_api_config('vsphere/vmware_ca_file').with_value('/etc/glance/vcenter-ca.pem')
        is_expected.to contain_glance_api_config('vsphere/vmware_task_poll_interval').with_value('6')
        is_expected.to contain_glance_api_config('vsphere/vmware_api_retry_count').with_value('11')
      end
      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('vsphere/store_description')
        is_expected.to contain_glance_cache_config('vsphere/weight').with_value(0)
        is_expected.to contain_glance_cache_config('vsphere/vmware_ca_file').with_value('/etc/glance/vcenter-ca.pem')
        is_expected.to contain_glance_cache_config('vsphere/vmware_task_poll_interval').with_value('6')
        is_expected.to contain_glance_cache_config('vsphere/vmware_api_retry_count').with_value('11')
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

      it_behaves_like 'glance::backend::multistore::vsphere'
    end
  end
end
