require 'spec_helper'

describe 'glance::backend::swift' do
  let :facts do
    {
      :osfamily => 'Debian'
    }
  end

  let :params do
    {
      :swift_store_user => 'user',
      :swift_store_key  => 'key',
    }
  end

  let :pre_condition do
    'class { "glance::api": keystone_password => "pass" }'
  end

  it { should contain_glance_api_config('DEFAULT/default_store').with_value('swift') }
  it { should contain_glance_api_config('DEFAULT/swift_store_key').with_value('key') }
  it { should contain_glance_api_config('DEFAULT/swift_store_user').with_value('user') }
  it { should contain_glance_api_config('DEFAULT/swift_store_auth_version').with_value('2') }
  it { should contain_glance_api_config('DEFAULT/swift_store_auth_address').with_value('127.0.0.1:5000/v2.0/') }
  it { should contain_glance_api_config('DEFAULT/swift_store_container').with_value('glance') }
  it { should contain_glance_api_config('DEFAULT/swift_store_create_container_on_put').with_value(false) }

  describe 'when overriding datadir' do
    let :params do
      {
        :swift_store_user => 'user',
        :swift_store_key  => 'key',
        :swift_store_auth_version  => '1',
        :swift_store_auth_address            => '127.0.0.2:8080/v1.0/',
        :swift_store_container               => 'swift',
        :swift_store_create_container_on_put => true
      }
    end
    it { should contain_glance_api_config('DEFAULT/swift_store_container').with_value('swift') }
    it { should contain_glance_api_config('DEFAULT/swift_store_create_container_on_put').with_value(true) }
    it { should contain_glance_api_config('DEFAULT/swift_store_auth_version').with_value('1') }
    it { should contain_glance_api_config('DEFAULT/swift_store_auth_address').with_value('127.0.0.2:8080/v1.0/') }
  end
end
