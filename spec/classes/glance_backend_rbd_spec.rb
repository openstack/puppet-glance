require 'spec_helper'

describe 'glance::backend::rbd' do
  let :facts do
    {
      :osfamily => 'Debian'
    }
  end

  let :params do
    {
      :rbd_store_user  => 'user',
    }
  end

  it { should contain_glance_api_config('DEFAULT/default_store').with_value('rbd') }
  it { should contain_glance_api_config('DEFAULT/rbd_store_user').with_value('user') }
  it { should contain_glance_api_config('DEFAULT/rbd_store_pool').with_value('images') }

  it { should contain_package('python-ceph').with(
      :name   => 'python-ceph',
      :ensure => 'present'
    )
  }

end
