# == Class: glance::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $facts['os_service_default']
#
class glance::key_manager (
  $backend = $facts['os_service_default'],
) {

  include glance::deps

  oslo::key_manager { 'glance_api_config':
    backend => $backend,
  }
}
