require 'spec_helper'
describe 'glance::notify::rabbitmq' do

  shared_examples_for 'glance::notify::rabbitmq' do
    describe 'when defaults with rabbit pass specified' do
      it { is_expected.to contain_glance_api_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>').with_secret(true) }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_userid').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/default_notification_exchange').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_glance_registry_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE DEFAULT>').with_secret(true) }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_userid').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/default_notification_exchange').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('<SERVICE DEFAULT>') }
    end

    describe 'when passing params and use ssl' do
      let :params do
        {
          :rabbit_password        => 'pass',
          :rabbit_userid          => 'guest2',
          :rabbit_host            => 'localhost2',
          :rabbit_port            => '5673',
          :rabbit_use_ssl         => true,
          :rabbit_durable_queues  => true,
          :kombu_reconnect_delay  => '5.0'
        }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('true') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_durable_queues').with_value(true) }
        it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('5.0') }

        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_durable_queues').with_value(true) }
        it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('5.0') }
      end
    end

    describe 'with rabbit ssl cert parameters' do
      let :params do
        {
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        }
      end
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }

      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1') }
    end

    describe 'with rabbit ssl disabled' do
      let :params do
        {
          :rabbit_use_ssl => false,
        }
      end

      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(false) }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(false) }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE DEFAULT>') }
    end

    describe 'when passing params for single rabbit host' do
      let :params do
        {
          :rabbit_password     => 'pass',
          :rabbit_userid       => 'guest2',
          :rabbit_host         => 'localhost2',
          :rabbit_port         => '5673',
          :rabbit_use_ssl      => true,
          :amqp_durable_queues => true,
        }
      end
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }

      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest2') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost2') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }
    end

    describe 'when passing params for multiple rabbit hosts' do
      let :params do
        {
          :rabbit_password => 'pass',
          :rabbit_userid   => 'guest3',
          :rabbit_hosts    => ['nonlocalhost3:5673', 'nonlocalhost4:5673']
        }
      end
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest3') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_hosts').with_value('nonlocalhost3:5673,nonlocalhost4:5673') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest3') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_hosts').with_value('nonlocalhost3:5673,nonlocalhost4:5673') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
    end

    describe 'a single rabbit_host with enable ha queues' do
      let :params do
         {
          :rabbit_password  => 'pass',
          :rabbit_userid    => 'guest3',
          :rabbit_ha_queues => true,
         }
      end

      it 'should contain rabbit_ha_queues' do
        is_expected.to contain_glance_api_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true')

        is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('true')
      end
    end

    describe 'when passing params for rabbitmq heartbeat' do
      let :params do
        {
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
        }
      end
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60') }
      it { is_expected.to contain_glance_api_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10') }

      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60') }
      it { is_expected.to contain_glance_registry_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10') }
    end

    describe 'when passing params transport_url' do
      let :params do
        {
          :default_transport_url => 'rabbit://user:pass@host:1234/virt',
        }
      end
      it { is_expected.to contain_glance_api_config('DEFAULT/transport_url').with_value('rabbit://user:pass@host:1234/virt') }
      it { is_expected.to contain_glance_registry_config('DEFAULT/transport_url').with_value('rabbit://user:pass@host:1234/virt') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::notify::rabbitmq'
    end
  end
end
