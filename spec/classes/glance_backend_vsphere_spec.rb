#
# Copyright (C) 2014 Mirantis
#
# Author: Steapn Rogov <srogov@mirantis.com>
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
# Unit tests for glance::backend::vsphere class
#

require 'spec_helper'

describe 'glance::backend::vsphere' do

  let :pre_condition do
    'class { "glance::api": keystone_password => "pass" }'
  end

  shared_examples_for 'glance with vsphere backend' do

    context 'when default parameters' do
      let :params do
        {
          :vcenter_host       => '10.0.0.1',
          :vcenter_user       => 'root',
          :vcenter_password   => '123456',
          :vcenter_datastores => 'Datacenter:Datastore',
          :vcenter_image_dir  => '/openstack_glance',
        }
      end
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/default_store').with_value('vsphere')
        is_expected.to contain_glance_api_config('glance_store/vmware_insecure').with_value('True')
        is_expected.to contain_glance_api_config('glance_store/vmware_server_host').with_value('10.0.0.1')
        is_expected.to contain_glance_api_config('glance_store/vmware_server_username').with_value('root')
        is_expected.to contain_glance_api_config('glance_store/vmware_server_password').with_value('123456')
        is_expected.to contain_glance_api_config('glance_store/vmware_store_image_dir').with_value('/openstack_glance')
        is_expected.to contain_glance_api_config('glance_store/vmware_task_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/vmware_api_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('glance_store/vmware_datastores').with_value('Datacenter:Datastore')
        is_expected.to contain_glance_api_config('glance_store/vmware_ca_file').with_value('<SERVICE DEFAULT>')
      end
      it 'not configures glance-glare.conf' do
        is_expected.to_not contain_glance_glare_config('glance_store/default_store').with_value('vsphere')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_insecure').with_value('True')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_server_host').with_value('10.0.0.1')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_server_username').with_value('root')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_server_password').with_value('123456')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_store_image_dir').with_value('/openstack_glance')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_task_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_api_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_datastores').with_value('Datacenter:Datastore')
        is_expected.to_not contain_glance_glare_config('glance_store/vmware_ca_file').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :vcenter_host               => '10.0.0.1',
          :vcenter_user               => 'root',
          :vcenter_password           => '123456',
          :vcenter_datastores         => 'Datacenter:Datastore',
          :vcenter_image_dir          => '/openstack_glance',
          :vcenter_ca_file            => '/etc/glance/vcenter-ca.pem',
          :vcenter_task_poll_interval => '6',
          :vcenter_api_retry_count    => '11',
          :glare_enabled              => true,
        }
      end
      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('glance_store/vmware_ca_file').with_value('/etc/glance/vcenter-ca.pem')
        is_expected.to contain_glance_api_config('glance_store/vmware_task_poll_interval').with_value('6')
        is_expected.to contain_glance_api_config('glance_store/vmware_api_retry_count').with_value('11')
      end

      it 'configures glance-glare.conf' do
        is_expected.to contain_glance_glare_config('glance_store/vmware_ca_file').with_value('/etc/glance/vcenter-ca.pem')
        is_expected.to contain_glance_glare_config('glance_store/vmware_task_poll_interval').with_value('6')
        is_expected.to contain_glance_glare_config('glance_store/vmware_api_retry_count').with_value('11')
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

      it_configures 'glance with vsphere backend'
    end
  end
end
