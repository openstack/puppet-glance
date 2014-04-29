require 'spec_helper'
describe 'glance::notify::rabbitmq' do
  let :facts do
    {
      :osfamily => 'Debian'
    }
  end

  let :pre_condition do
    'class { "glance::api": keystone_password => "pass" }'
  end

  let :params do
    {:rabbit_password => 'pass'}
  end

  it { should contain_glance_api_config('DEFAULT/notifier_driver').with_value('rabbit') }
  it { should contain_glance_api_config('DEFAULT/rabbit_password').with_value('pass') }
  it { should contain_glance_api_config('DEFAULT/rabbit_userid').with_value('guest') }
  it { should contain_glance_api_config('DEFAULT/rabbit_host').with_value('localhost') }
  it { should contain_glance_api_config('DEFAULT/rabbit_port').with_value('5672') }
  it { should contain_glance_api_config('DEFAULT/rabbit_virtual_host').with_value('/') }
  it { should contain_glance_api_config('DEFAULT/rabbit_notification_exchange').with_value('glance') }
  it { should contain_glance_api_config('DEFAULT/rabbit_notification_topic').with_value('notifications') }

  describe 'when passing params and use ssl' do
    let :params do
      {
        :rabbit_password        => 'pass',
        :rabbit_userid          => 'guest2',
        :rabbit_host            => 'localhost2',
        :rabbit_port            => '5673',
        :rabbit_use_ssl         => true,
        :rabbit_durable_queues  => true,
      }
      it { should contain_glance_api_config('DEFAULT/rabbit_userid').with_value('guest2') }
      it { should contain_glance_api_config('DEFAULT/rabbit_host').with_value('localhost2') }
      it { should contain_glance_api_config('DEFAULT/rabbit_port').with_value('5673') }
      it { should contain_glance_api_config('DEFAULT/rabbit_use_ssl').with_value('true') }
      it { should contain_glance_api_config('DEFAULT/kombu_ssl_ca_certs').with_ensure('absent') }
      it { should contain_glance_api_config('DEFAULT/kombu_ssl_certfile').with_ensure('absent') }
      it { should contain_glance_api_config('DEFAULT/kombu_ssl_keyfile').with_ensure('absent') }
      it { should contain_glance_api_config('DEFAULT/kombu_ssl_version').with_value('SSLv3') }
      it { should contain_glance_api_config('DEFAULT/rabbit_durable_queues').with_value('true') }
    end
  end

  describe 'with rabbit ssl cert parameters' do
    let :params do
      {
        :rabbit_password        => 'pass',
        :rabbit_use_ssl     => 'true',
        :kombu_ssl_ca_certs => '/etc/ca.cert',
        :kombu_ssl_certfile => '/etc/certfile',
        :kombu_ssl_keyfile  => '/etc/key',
        :kombu_ssl_version  => 'TLSv1',
      }
    end
    it { should contain_glance_api_config('DEFAULT/rabbit_use_ssl').with_value(true) }
    it { should contain_glance_api_config('DEFAULT/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
    it { should contain_glance_api_config('DEFAULT/kombu_ssl_certfile').with_value('/etc/certfile') }
    it { should contain_glance_api_config('DEFAULT/kombu_ssl_keyfile').with_value('/etc/key') }
    it { should contain_glance_api_config('DEFAULT/kombu_ssl_version').with_value('TLSv1') }
  end
end
