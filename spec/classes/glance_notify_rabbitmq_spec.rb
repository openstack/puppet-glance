require 'spec_helper'
describe 'glance::notify::rabbitmq' do

  shared_examples_for 'glance::notify::rabbitmq' do
    describe 'when using defaults' do
      it { is_expected.to contain_oslo__messaging__rabbit('glance_api_config').with(
        :rabbit_ha_queues                => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
        :heartbeat_rate                  => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread            => '<SERVICE DEFAULT>',
        :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
        :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
        :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
        :kombu_ssl_version               => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
        :kombu_failover_strategy         => '<SERVICE DEFAULT>',
        :amqp_durable_queues             => '<SERVICE DEFAULT>',
        :kombu_compression               => '<SERVICE DEFAULT>',
        :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
        :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
        :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
      ) }

      it { is_expected.to contain_oslo__messaging__default('glance_api_config').with(
        :executor_thread_pool_size => '<SERVICE DEFAULT>',
        :transport_url             => '<SERVICE DEFAULT>',
        :rpc_response_timeout      => '<SERVICE DEFAULT>',
        :control_exchange          => '<SERVICE DEFAULT>',
      ) }

      it { is_expected.to contain_oslo__messaging__notifications('glance_api_config').with(
        :driver        => '<SERVICE DEFAULT>',
        :transport_url => '<SERVICE DEFAULT>',
        :topics        => '<SERVICE DEFAULT>',
      ) }
    end

    describe 'when passing params and use ssl' do
      let :params do
        {
          :default_transport_url              => 'rabbit://user:pass@host:1234/virt',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'glance',
          :executor_thread_pool_size          => 64,
          :notification_transport_url         => 'rabbit://user:pass@alt_host:1234/virt',
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :rabbit_qos_prefetch_count          => 0,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => true,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_ssl                     => true,
          :kombu_ssl_ca_certs                 => '/etc/ca.cert',
          :kombu_ssl_certfile                 => '/etc/certfile',
          :kombu_ssl_keyfile                  => '/etc/key',
          :kombu_ssl_version                  => 'TLSv1',
          :kombu_reconnect_delay              => '5.0',
          :kombu_failover_strategy            => 'shuffle',
          :rabbit_notification_topic          => 'notification',
          :amqp_durable_queues                => true,
          :kombu_compression                  => 'gzip',
          :notification_driver                => 'messagingv2',
        }
      end

      it { is_expected.to contain_oslo__messaging__rabbit('glance_api_config').with(
        :rabbit_ha_queues                => true,
        :heartbeat_timeout_threshold     => '60',
        :heartbeat_rate                  => '10',
        :heartbeat_in_pthread            => true,
        :rabbit_qos_prefetch_count       => 0,
        :rabbit_use_ssl                  => true,
        :kombu_ssl_ca_certs              => '/etc/ca.cert',
        :kombu_ssl_certfile              => '/etc/certfile',
        :kombu_ssl_keyfile               => '/etc/key',
        :kombu_ssl_version               => 'TLSv1',
        :kombu_reconnect_delay           => '5.0',
        :kombu_failover_strategy         => 'shuffle',
        :amqp_durable_queues             => true,
        :kombu_compression               => 'gzip',
        :rabbit_quorum_queue             => true,
        :rabbit_transient_quorum_queue   => true,
        :rabbit_quorum_delivery_limit    => 3,
        :rabbit_quorum_max_memory_length => 5,
        :rabbit_quorum_max_memory_bytes  => 1073741824,
      ) }

      it { is_expected.to contain_oslo__messaging__default('glance_api_config').with(
        :executor_thread_pool_size => 64,
        :transport_url             => 'rabbit://user:pass@host:1234/virt',
        :rpc_response_timeout      => '120',
        :control_exchange          => 'glance',
      ) }

      it { is_expected.to contain_oslo__messaging__notifications('glance_api_config').with(
        :driver        => 'messagingv2',
        :transport_url => 'rabbit://user:pass@alt_host:1234/virt',
        :topics        => 'notification',
      ) }
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
