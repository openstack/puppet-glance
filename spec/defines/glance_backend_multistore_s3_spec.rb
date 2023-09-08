#
# Copyright 2021 Red Hat, Inc.
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
# Unit tests for glance::backend::multistore::s3
#

require 'spec_helper'

describe 'glance::backend::multistore::s3' do
  let (:title) { 's3' }

  let :params do
    {
      :s3_store_host                    => 'host',
      :s3_store_access_key              => 'access',
      :s3_store_secret_key              => 'secret',
      :s3_store_bucket                  => 'bucket',
    }
  end

  shared_examples_for 'glance::backend::multistore::s3' do
    context 'with defaults' do
      it 'installs boto3' do
        is_expected.to contain_package('python-boto3').with(
          :ensure => 'installed',
          :name   => 'python3-boto3',
          :tag    => ['openstack', 'glance-package']
        )
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('s3/store_description').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/weight').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/s3_store_host').with_value('host')
        is_expected.to contain_glance_api_config('s3/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_api_config('s3/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_api_config('s3/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_api_config('s3/s3_store_create_bucket_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/s3_store_bucket_url_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/s3_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/s3_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('s3/s3_store_thread_pools').with_value('<SERVICE DEFAULT>')
      end

      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('s3/store_description')
        is_expected.to contain_glance_cache_config('s3/weight').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('s3/s3_store_host').with_value('host')
        is_expected.to contain_glance_cache_config('s3/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_cache_config('s3/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_cache_config('s3/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_cache_config('s3/s3_store_create_bucket_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('s3/s3_store_bucket_url_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('s3/s3_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('s3/s3_store_large_object_chunk_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_cache_config('s3/s3_store_thread_pools').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding datadir' do
      before :each do
        params.merge!({
          :store_description                => 's3store',
          :weight                           => 0,
          :s3_store_create_bucket_on_put    => false,
          :s3_store_bucket_url_format       => 'auto',
          :s3_store_large_object_size       => 100,
          :s3_store_large_object_chunk_size => 10,
          :s3_store_thread_pools            => 11,
          :package_ensure                   => 'latest',
        })
      end

      it 'installs boto3' do
        is_expected.to contain_package('python-boto3').with(
          :ensure => 'latest',
          :name   => 'python3-boto3',
          :tag    => ['openstack', 'glance-package']
        )
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('s3/store_description').with_value('s3store')
        is_expected.to contain_glance_api_config('s3/weight').with_value(0)
        is_expected.to contain_glance_api_config('s3/s3_store_host').with_value('host')
        is_expected.to contain_glance_api_config('s3/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_api_config('s3/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_api_config('s3/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_api_config('s3/s3_store_create_bucket_on_put').with_value(false)
        is_expected.to contain_glance_api_config('s3/s3_store_bucket_url_format').with_value('auto')
        is_expected.to contain_glance_api_config('s3/s3_store_large_object_size').with_value(100)
        is_expected.to contain_glance_api_config('s3/s3_store_large_object_chunk_size').with_value(10)
        is_expected.to contain_glance_api_config('s3/s3_store_thread_pools').with_value(11)
      end

      it 'configures glance-cache.conf' do
        is_expected.to_not contain_glance_cache_config('s3/store_description')
        is_expected.to contain_glance_cache_config('s3/weight').with_value(0)
        is_expected.to contain_glance_cache_config('s3/s3_store_host').with_value('host')
        is_expected.to contain_glance_cache_config('s3/s3_store_access_key').with_value('access').with_secret(true)
        is_expected.to contain_glance_cache_config('s3/s3_store_secret_key').with_value('secret').with_secret(true)
        is_expected.to contain_glance_cache_config('s3/s3_store_bucket').with_value('bucket')
        is_expected.to contain_glance_cache_config('s3/s3_store_create_bucket_on_put').with_value(false)
        is_expected.to contain_glance_cache_config('s3/s3_store_bucket_url_format').with_value('auto')
        is_expected.to contain_glance_cache_config('s3/s3_store_large_object_size').with_value(100)
        is_expected.to contain_glance_cache_config('s3/s3_store_large_object_chunk_size').with_value(10)
        is_expected.to contain_glance_cache_config('s3/s3_store_thread_pools').with_value(11)
      end
    end

    context 'when package management is disabled' do
      before :each do
        params.merge!({
          :manage_packages => false
        })
      end

      it 'does not manage packages' do
        is_expected.to_not contain_package('python-boto3')
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

      it_behaves_like 'glance::backend::multistore::s3'
    end
  end
end
