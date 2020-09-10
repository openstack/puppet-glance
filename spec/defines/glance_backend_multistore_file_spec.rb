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
# Unit tests for glance::backend::multistore::file
#

require 'spec_helper'

describe 'glance::backend::multistore::file' do
  let (:title) { 'file' }

  shared_examples_for 'glance::backend::multistore::file' do
    it 'configures glance-api.conf' do
      is_expected.to contain_glance_api_config('file/store_description').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('file/filesystem_thin_provisioning').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('file/filesystem_store_datadir').with_value('<SERVICE DEFAULT>')
    end

    it 'configures glance-cache.conf' do
      is_expected.to_not contain_glance_cache_config('file/store_description')
      is_expected.to contain_glance_cache_config('file/filesystem_store_datadir').with_value('<SERVICE DEFAULT>')
    end

    describe 'when overriding datadir' do
      let :params do
        {
          :filesystem_store_datadir     => '/tmp/',
          :filesystem_thin_provisioning => 'true',
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('file/filesystem_store_datadir').with_value('/tmp/')
        is_expected.to contain_glance_api_config('file/filesystem_thin_provisioning').with_value('true')
      end

      it 'configures glance-cache.conf' do
        is_expected.to contain_glance_cache_config('file/filesystem_store_datadir').with_value('/tmp/')
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

      it_behaves_like 'glance::backend::multistore::file'
    end
  end
end
