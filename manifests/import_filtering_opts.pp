# == Class: glance::import_filtering_opts
#
# Configure import filterting options
#
# === Parameters
#
# [*allowed_schemes*]
#  (Optional) Url schemes allowed for web-download.
#  Defaults to $facts['os_service_default']
#
# [*disallowed_schemes*]
#  (Optional) Url schemes disallowed for web-download.
#  Defaults to $facts['os_service_default']
#
# [*allowed_hosts*]
#  (Optional) Target hosts allowed for web-download.
#  Defaults to $facts['os_service_default']
#
# [*disallowed_hosts*]
#  (Optional) Target hosts disallowed for web-download.
#  Defaults to $facts['os_service_default']
#
# [*allowed_ports*]
#  (Optional) Ports allowed for web-download.
#  Defaults to $facts['os_service_default']
#
# [*disallowed_ports*]
#  (Optional) Ports disallowed for web-download.
#  Defaults to $facts['os_service_default']
#
class glance::import_filtering_opts (
  $allowed_schemes    = $facts['os_service_default'],
  $disallowed_schemes = $facts['os_service_default'],
  $allowed_hosts      = $facts['os_service_default'],
  $disallowed_hosts   = $facts['os_service_default'],
  $allowed_ports      = $facts['os_service_default'],
  $disallowed_ports   = $facts['os_service_default'],
) {
  include glance::deps
  include glance::params

  $allowed_schemes_real = is_service_default($allowed_schemes) ? {
    true    => $allowed_schemes,
    default => sprintf('[%s]', join(any2array($allowed_schemes), ','))
  }
  $disallowed_schemes_real = is_service_default($disallowed_schemes) ? {
    true    => $disallowed_schemes,
    default => sprintf('[%s]', join(any2array($disallowed_schemes), ','))
  }
  $allowed_hosts_real = is_service_default($allowed_hosts) ? {
    true    => $allowed_hosts,
    default => sprintf('[%s]', join(any2array($allowed_hosts), ','))
  }
  $disallowed_hosts_real = is_service_default($disallowed_hosts) ? {
    true    => $disallowed_hosts,
    default => sprintf('[%s]', join(any2array($disallowed_hosts), ','))
  }
  $allowed_ports_real = is_service_default($allowed_ports) ? {
    true    => $allowed_ports,
    default => sprintf('[%s]', join(any2array($allowed_ports), ','))
  }
  $disallowed_ports_real = is_service_default($disallowed_ports) ? {
    true    => $disallowed_ports,
    default => sprintf('[%s]', join(any2array($disallowed_ports), ','))
  }

  glance_api_config {
    'import_filtering_opts/allowed_schemes':    value => $allowed_schemes_real;
    'import_filtering_opts/disallowed_schemes': value => $disallowed_schemes_real;
    'import_filtering_opts/allowed_hosts':      value => $allowed_hosts_real;
    'import_filtering_opts/disallowed_hosts':   value => $disallowed_hosts_real;
    'import_filtering_opts/allowed_ports':      value => $allowed_ports_real;
    'import_filtering_opts/disallowed_ports':   value => $disallowed_ports_real;
  }
}
