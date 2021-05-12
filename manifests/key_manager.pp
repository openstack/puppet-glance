# == Class: glance::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $::os_service_default
#
class glance::key_manager (
  $backend = $::os_service_default,
) {

  include glance::deps

  $backend_real = pick($glance::api::keymgr_backend, $backend)

  oslo::key_manager { 'glance_api_config':
    backend => $backend_real,
  }
}
