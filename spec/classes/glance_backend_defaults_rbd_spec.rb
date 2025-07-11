require 'spec_helper'

describe 'glance::backend::defaults::rbd' do
  shared_examples 'glance::backend::defaults::rbd' do
    context 'with default params' do
      it 'configures glance-api.conf' do
        should contain_glance_api_config('backend_defaults/rbd_store_user').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('backend_defaults/rbd_store_pool').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('backend_defaults/rbd_store_ceph_conf').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('backend_defaults/rbd_store_chunk_size').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('backend_defaults/rbd_thin_provisioning').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('backend_defaults/rados_connect_timeout').with_value('<SERVICE DEFAULT>')
      end
      it 'configures glance-cache.conf' do
        should contain_glance_cache_config('backend_defaults/rbd_store_user').with_value('<SERVICE DEFAULT>')
        should contain_glance_cache_config('backend_defaults/rbd_store_pool').with_value('<SERVICE DEFAULT>')
        should contain_glance_cache_config('backend_defaults/rbd_store_ceph_conf').with_value('<SERVICE DEFAULT>')
        should contain_glance_cache_config('backend_defaults/rbd_store_chunk_size').with_value('<SERVICE DEFAULT>')
        should contain_glance_cache_config('backend_defaults/rbd_thin_provisioning').with_value('<SERVICE DEFAULT>')
        should contain_glance_cache_config('backend_defaults/rados_connect_timeout').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when passing params' do
      let :params do
        {
          :rbd_store_user        => 'user',
          :rbd_store_chunk_size  => '2',
          :rbd_thin_provisioning => 'true',
          :rados_connect_timeout => '30',
        }
      end

      it 'configures glance-api.conf' do
        should contain_glance_api_config('backend_defaults/rbd_store_user').with_value('user')
        should contain_glance_api_config('backend_defaults/rbd_store_chunk_size').with_value('2')
        should contain_glance_api_config('backend_defaults/rbd_thin_provisioning').with_value('true')
        should contain_glance_api_config('backend_defaults/rados_connect_timeout').with_value('30')
      end
      it 'configures glance-cache.conf' do
        should contain_glance_cache_config('backend_defaults/rbd_store_user').with_value('user')
        should contain_glance_cache_config('backend_defaults/rbd_store_chunk_size').with_value('2')
        should contain_glance_cache_config('backend_defaults/rbd_thin_provisioning').with_value('true')
        should contain_glance_cache_config('backend_defaults/rados_connect_timeout').with_value('30')
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

      it_behaves_like 'glance::backend::defaults::rbd'
    end
  end
end
