# == Class: glance::notify::qpid
#
# used to configure qpid notifications for glance
# Deprecated class
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
  $qpid_password = undef,
  $qpid_username = undef,
  $qpid_hostname = undef,
  $qpid_port     = undef,
  $qpid_protocol = undef
) inherits glance::api {

  warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
}
