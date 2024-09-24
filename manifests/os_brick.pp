# == Class: glance::os_brick
#
# Configure os_brick options
#
# === Parameters:
#
# [*lock_path*]
#   (Optional) Directory to use for os-brick lock files.
#   Defaults to $facts['os_service_default']
#
class glance::os_brick(
  $lock_path = $facts['os_service_default'],
) {

  oslo::os_brick { 'glance_api_config':
    lock_path => $lock_path
  }
  oslo::os_brick { 'glance_cache_config':
    lock_path => $lock_path
  }
}
