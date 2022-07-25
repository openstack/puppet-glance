# these parameters need to be accessed from several locations and
# should be considered to be constant
class glance::params {
  include openstacklib::defaults

  $client_package_name = 'python3-glanceclient'

  $cache_cleaner_command = 'glance-cache-cleaner'
  $cache_pruner_command  = 'glance-cache-pruner'
  $user                  = 'glance'
  $group                 = 'glance'
  $boto3_package_name    = 'python3-boto3'

  $glance_wsgi_script_source = '/usr/bin/glance-wsgi-api'

  case $::osfamily {
    'RedHat': {
      $package_name            = 'openstack-glance'
      $api_package_name        = undef
      $api_service_name        = 'openstack-glance-api'
      $pyceph_package_name     = 'python3-rbd'
      $lock_path               = '/var/lib/glance/tmp'
      $glance_wsgi_script_path = '/var/www/cgi-bin/glance'
    }
    'Debian': {
      $package_name            = undef
      $api_package_name        = 'glance-api'
      $api_service_name        = 'glance-api'
      if $::operatingsystem == 'Debian' {
        $pyceph_package_name   = 'python3-ceph'
      } else {
        $pyceph_package_name   = 'python3-rbd'
      }
      $lock_path               = '/var/lock/glance'
      $glance_wsgi_script_path = '/usr/lib/cgi-bin/glance'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
