# these parameters need to be accessed from several locations and
# should be considered to be constant
class glance::params {
  include openstacklib::defaults

  $client_package_name = 'python3-glanceclient'

  $cache_cleaner_command = 'glance-cache-cleaner'
  $cache_pruner_command  = 'glance-cache-pruner'
  $group                 = 'glance'

  case $::osfamily {
    'RedHat': {
      $package_name          = 'openstack-glance'
      $api_package_name      = undef
      $api_service_name      = 'openstack-glance-api'
      $pyceph_package_name   = 'python3-rbd'
    }
    'Debian': {
      $package_name          = undef
      $api_package_name      = 'glance-api'
      $api_service_name      = 'glance-api'
      if $::os_package_type == 'debian' {
        $pyceph_package_name = 'python-ceph'
      } else {
        $pyceph_package_name = 'python3-rbd'
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
