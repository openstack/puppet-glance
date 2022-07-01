# these parameters need to be accessed from several locations and
# should be considered to be constant
class glance::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers

  $client_package_name = "python${pyvers}-glanceclient"

  $cache_cleaner_command = 'glance-cache-cleaner'
  $cache_pruner_command  = 'glance-cache-pruner'
  $group                 = 'glance'

  case $::osfamily {
    'RedHat': {
      $api_package_name      = 'openstack-glance'
      $registry_package_name = 'openstack-glance'
      $api_service_name      = 'openstack-glance-api'
      $registry_service_name = 'openstack-glance-registry'
      $pyceph_package_name   = "python${pyvers}-rbd"
      $lock_path             = '/var/lib/glance/tmp'
    }
    'Debian': {
      $api_package_name      = 'glance-api'
      $registry_package_name = 'glance-registry'
      $api_service_name      = 'glance-api'
      $registry_service_name = 'glance-registry'
      if $::os_package_type == 'debian' {
        $pyceph_package_name = "python${pyvers}-ceph"
      } else {
        $pyceph_package_name = "python${pyvers}-rbd"
      }
      $lock_path             = '/var/lock/glance'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
