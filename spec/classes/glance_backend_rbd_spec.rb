require 'spec_helper'

describe 'glance::backend::rbd' do
  shared_examples 'glance::backend::rbd' do
    context 'with default params' do
      it { should contain_glance_api_config('glance_store/default_store').with_value('rbd') }
      it { should contain_glance_api_config('glance_store/rbd_store_pool').with_value('<SERVICE DEFAULT>') }
      it { should contain_glance_api_config('glance_store/rbd_store_ceph_conf').with_value('<SERVICE DEFAULT>') }
      it { should contain_glance_api_config('glance_store/rbd_store_chunk_size').with_value('<SERVICE DEFAULT>') }
      it { should contain_glance_api_config('glance_store/rbd_thin_provisioning').with_value('<SERVICE DEFAULT>') }
      it { should contain_glance_api_config('glance_store/rados_connect_timeout').with_value('<SERVICE DEFAULT>')}
      it { should contain_glance_api_config('glance_store/rbd_store_user').with_value('<SERVICE DEFAULT>')}

      it { should contain_package('python-ceph').with(
        :name   => platform_params[:pyceph_package_name],
        :ensure => 'installed'
      )}
    end

    context 'when passing params' do
      let :params do
        {
          :rbd_store_user        => 'user',
          :rbd_store_chunk_size  => '2',
          :rbd_thin_provisioning => 'true',
          :package_ensure        => 'latest',
          :rados_connect_timeout => '30',
        }
      end

      it { should contain_glance_api_config('glance_store/rbd_store_user').with_value('user') }
      it { should contain_glance_api_config('glance_store/rbd_store_chunk_size').with_value('2') }
      it { should contain_glance_api_config('glance_store/rbd_thin_provisioning').with_value('true') }
      it { should contain_glance_api_config('glance_store/rados_connect_timeout').with_value('30')}

      it { should contain_package('python-ceph').with(
        :name   => platform_params[:pyceph_package_name],
        :ensure => 'latest'
     )}
    end

    context 'when not managing packages' do
      let :params do
        {
          :manage_packages => false,
        }
      end

      it { should_not contain_package('python-ceph') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :pyceph_package_name => 'python3-ceph' }
        when 'RedHat'
          { :pyceph_package_name => 'python3-rbd' }
        end
      end

      it_behaves_like 'glance::backend::rbd'
    end
  end
end
