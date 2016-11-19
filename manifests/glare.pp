# == Class glance::glare
#
# Configure Glare Glare service in glance
#
# == Parameters
#
# [*package_ensure*]
#   (optional) Ensure state for package. On RedHat platforms this
#   setting is ignored and the setting from the glance class is used
#   because there is only one glance package. Defaults to 'present'.
#
# [*bind_host*]
#   (optional) The address of the host to bind to.
#   Default: 0.0.0.0
#
# [*bind_port*]
#   (optional) The port the server should bind to.
#   Default: 9494
#
# [*backlog*]
#   (optional) Backlog requests when creating socket
#   Default: 4096
#
# [*workers*]
#   (optional) Number of Glance Glare worker processes to start
#   Default: $::os_workers.
#
# [*auth_strategy*]
#   (optional) Type is authorization being used.
#   Defaults to 'keystone'
#
# [*pipeline*]
#   (optional) Partial name of a pipeline in your paste configuration file with the
#   service name removed.
#   Defaults to 'keystone'.
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*stores*]
#   (optional) List of which store classes and store class locations are
#    currently known to glance at startup.
#    Defaults to false.
#    Example: ['glance.store.filesystem.Store','glance.store.http.Store']
#
# [*default_store*]
#   (optional) The default backend store, should be given as a string. Value
#   must be provided if more than one store is listed in 'stores'.
#   Defaults to undef
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
class glance::glare(
  $package_ensure            = 'present',
  $bind_host                 = '0.0.0.0',
  $bind_port                 = '9494',
  $backlog                   = '4096',
  $workers                   = $::os_workers,
  $auth_strategy             = 'keystone',
  $pipeline                  = 'keystone',
  $manage_service            = true,
  $enabled                   = true,
  $cert_file                 = $::os_service_default,
  $key_file                  = $::os_service_default,
  $ca_file                   = $::os_service_default,
  $stores                    = false,
  $default_store             = undef,
  $multi_store               = false,
  $os_region_name            = 'RegionOne',
) inherits glance {

  include ::glance::deps
  include ::glance::policy
  include ::glance::glare::db
  include ::glance::glare::logging

  if ( $glance::params::glare_package_name != $glance::params::registry_package_name ) {
    ensure_packages('glance-glare', {
      ensure => $package_ensure,
      tag    => ['openstack', 'glance-package'],
    })
  }

  glance_glare_config {
    'DEFAULT/bind_host':           value => $bind_host;
    'DEFAULT/bind_port':           value => $bind_port;
    'DEFAULT/backlog':             value => $backlog;
    'DEFAULT/workers':             value => $workers;
    'glance_store/os_region_name': value => $os_region_name;
  }

  if $default_store {
    $default_store_real = $default_store
  }

  if $stores {
    validate_array($stores)
    $stores_real = $stores
  }

  if !empty($stores_real) {
    $final_stores_real = join($stores_real, ',')
    if !$default_store_real {
      warning("default_store not provided, it will be automatically set to ${stores_real[0]}")
      $default_store_real = $stores_real[0]
    }
  } elsif $default_store_real {
    $final_stores_real = $default_store
  } else {
    warning('Glance-Glare is being provisioned without any stores configured')
  }

  if $default_store_real and $multi_store {
    glance_glare_config {
      'glance_store/default_store': value => $default_store_real;
    }
  } elsif $multi_store {
    glance_glare_config {
      'glance_store/default_store': ensure => absent;
    }
  }

  if $final_stores_real {
    glance_glare_config {
      'glance_store/stores': value => $final_stores_real;
    }
  } else {
    glance_glare_config {
      'glance_store/stores': ensure => absent;
    }
  }

  if $pipeline != '' {
    validate_re($pipeline, '^(\w+([+]\w+)*)*$')
    glance_glare_config {
      'paste_deploy/flavor':
        ensure => present,
        value  => $pipeline,
    }
  } else {
    glance_glare_config { 'paste_deploy/flavor': ensure => absent }
  }

  # keystone config
  if $auth_strategy == 'keystone' {
    include ::glance::glare::authtoken
  }

  # SSL Options
  glance_glare_config {
    'DEFAULT/cert_file': value => $cert_file;
    'DEFAULT/key_file' : value => $key_file;
    'DEFAULT/ca_file'  : value => $ca_file;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'glance-glare':
    ensure     => $service_ensure,
    name       => $::glance::params::glare_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'glance-service',
  }
}
