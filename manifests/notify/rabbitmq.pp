#
# used to configure rabbitmq notifications for glance
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (optional) Connection url for oslo messaging notification backend. An
#   example rabbit url would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $::os_service_default
#
#  [*rabbit_password*]
#   (Optional) The RabbitMQ password. (string value)
#   Defaults to $::os_service_default
#
#  [*rabbit_userid*]
#   (Optional) The RabbitMQ userid. (string value)
#   Defaults to $::os_service_default
#
#  [*rabbit_host*]
#   (Optional) The RabbitMQ broker address where a single node is used.
#   (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#   (Optional) RabbitMQ HA cluster host:port pairs. (array value)
#   Defaults to $::os_service_default
#
#  [*rabbit_port*]
#   (Optional) The RabbitMQ broker port where a single node is used.
#   (port value)
#   Defaults to $::os_service_default
#
#  [*rabbit_virtual_host*]
#   (Optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default.
#
#  [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_version*]
#   (Optional) SSL version to use (valid only if SSL enabled). '
#   Valid values are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1,
#   and TLSv1_2 may be available on some distributions. (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
#  [*rabbit_notification_exchange*]
#    Exchange name for sending notifications (string value)
#    Defaults to $::os_service_default
#
#  [*rabbit_notification_topic*]
#    AMQP topic used for OpenStack notifications. (list value)
#    Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
#  [*notification_driver*]
#    The Drivers(s) to handle sending notifications. Possible values are
#    messaging, messagingv2, routing, log, test, noop (multi valued)
#   Defaults to $::os_service_default
#
class glance::notify::rabbitmq(
  $default_transport_url              = $::os_service_default,
  $notification_transport_url         = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_host                        = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $rabbit_notification_exchange       = $::os_service_default,
  $rabbit_notification_topic          = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $notification_driver                = $::os_service_default,
) {

  include ::glance::deps

  oslo::messaging::rabbit { ['glance_api_config', 'glance_registry_config']:
    rabbit_password             => $rabbit_password,
    rabbit_userid               => $rabbit_userid,
    rabbit_host                 => $rabbit_host,
    rabbit_port                 => $rabbit_port,
    rabbit_hosts                => $rabbit_hosts,
    rabbit_virtual_host         => $rabbit_virtual_host,
    rabbit_ha_queues            => $rabbit_ha_queues,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
  }

  oslo::messaging::default { ['glance_api_config', 'glance_registry_config']:
    transport_url => $default_transport_url,
  }

  oslo::messaging::notifications { ['glance_api_config', 'glance_registry_config']:
    driver        => $notification_driver,
    transport_url => $notification_transport_url,
    topics        => $rabbit_notification_topic,
  }

  glance_api_config {
    'oslo_messaging_rabbit/default_notification_exchange': value => $rabbit_notification_exchange;
  }

  glance_registry_config {
    'oslo_messaging_rabbit/default_notification_exchange': value => $rabbit_notification_exchange;
  }
}
