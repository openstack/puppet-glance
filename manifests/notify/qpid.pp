# == Class: glance::notify::qpid
#
# used to configure qpid notifications for glance
#
# === Parameters:
#
# [*qpid_password*]
#   (required) Password to connect to the qpid server.
#
# [*qpid_username*]
#   (Optional) User to connect to the qpid server.
#   Defaults to 'guest'.
#
# [*qpid_hostname*]
#   (Optional) IP or hostname of the qpid server.
#   Defaults to 'localhost'.
#
# [*qpid_port*]
#   (Optional) Port of the qpid server.
#   Defaults to 5672.
#
# [*qpid_protocol*]
#   (Optional) Protocol to use for qpid (tcp/ssl).
#   Defaults to tcp.
#
class glance::notify::qpid(
  $qpid_password,
  $qpid_username = 'guest',
  $qpid_hostname = 'localhost',
  $qpid_port     = '5672',
  $qpid_protocol = 'tcp'
) inherits glance::api {

  glance_api_config {
    'DEFAULT/notifier_driver':           value => 'qpid';
    'oslo_messaging_qpid/qpid_hostname': value => $qpid_hostname;
    'oslo_messaging_qpid/qpid_port':     value => $qpid_port;
    'oslo_messaging_qpid/qpid_protocol': value => $qpid_protocol;
    'oslo_messaging_qpid/qpid_username': value => $qpid_username;
    'oslo_messaging_qpid/qpid_password': value => $qpid_password, secret => true;
  }

}
