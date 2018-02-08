# == Class: glance::registry
#
# Installs and configures glance-registry
#
# === Parameters
#
#  [*package_ensure*]
#    (optional) Ensure state for package. Defaults to 'present'.  On RedHat
#    platforms this setting is ignored and the setting from the glance class is
#    used because there is only one glance package.
#
#  [*debug*]
#    (optional) Enable debug logs (true|false). Defaults to undef.
#
#  [*bind_host*]
#    (optional) The address of the host to bind to.
#    Defaults to $::os_service_default.
#
#  [*bind_port*]
#    (optional) The port the server should bind to. Defaults to '9191'.
#
#  [*workers*]
#    (optional) The number of child process workers that will be
#    created to service Registry requests.
#    Defaults to: $::os_workers.
#
#  [*log_file*]
#    (optional) Log file for glance-registry.
#    If set to $::os_service_default, it will not log to any file.
#    Defaults to undef.
#
#  [*log_dir*]
#    (optional) directory to which glance logs are sent.
#    If set to $::os_service_default, it will not log to any directory.
#    Defaults to undef.
#
#  [*database_connection*]
#    (optional) Connection url to connect to glance database.
#    Defaults to undef
#
#  [*database_idle_timeout*]
#    (optional) Timeout before idle db connections are reaped.
#    Defaults to undef
#
#  [*database_max_retries*]
#    (Optional) Maximum number of database connection retries during startup.
#    Set to -1 to specify an infinite retry count.
#    Defaults to undef.
#
#  [*database_retry_interval*]
#    (optional) Interval between retries of opening a database connection.
#    Defaults to undef.
#
#  [*database_min_pool_size*]
#    (optional) Minimum number of SQL connections to keep open in a pool.
#    Defaults to undef.
#
#  [*database_max_pool_size*]
#    (optional) Maximum number of SQL connections to keep open in a pool.
#    Defaults to undef.
#
#  [*database_max_overflow*]
#    (optional) If set, use this value for max_overflow with sqlalchemy.
#    Defaults to undef.
#
#  [*auth_strategy*]
#    (optional) Type is authorization being used.
#    Defaults to 'keystone'
#
#  [*pipeline*]
#    (optional) Partial name of a pipeline in your paste configuration
#     file with the service name removed.
#     Defaults to 'keystone'.
#
#  [*use_syslog*]
#    (optional) Use syslog for logging.
#    Defaults to undef.
#
#  [*use_stderr*]
#    (optional) Use stderr for logging
#    Defaults to undef.
#
#  [*log_facility*]
#    (optional) Syslog facility to receive log lines.
#    Defaults to undef.
#
#  [*manage_service*]
#    (optional) If Puppet should manage service startup / shutdown.
#    Defaults to true.
#
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true.
#
#  [*purge_config*]
#    (optional) Whether to create only the specified config values in
#    the glance registry config file.
#    Defaults to false.
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting registry server securely
#   Defaults to $::os_service_default.
#
# [*key_file*]
#   (optional) Private key file to use when starting registry server securely
#   Defaults to $::os_service_default.
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default.
#
#  [*os_region_name*]
#    (optional) Sets the keystone region to use.
#    Defaults to $::os_service_default.
#
#  [*enable_v1_registry*]
#    (optional) Deploy the v1 API Registry service.
#    If glance::api::enable_v1_api is set to True, this option also needs to be
#    set to True.
#    If your OpenStack deployment is only using Glance API v2, this option
#    should be set to False.
#    Defaults to false.
#
class glance::registry(
  $package_ensure          = 'present',
  $debug                   = undef,
  $bind_host               = $::os_service_default,
  $bind_port               = '9191',
  $workers                 = $::os_workers,
  $log_file                = undef,
  $log_dir                 = undef,
  $database_connection     = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
  $auth_strategy           = 'keystone',
  $pipeline                = 'keystone',
  $use_syslog              = undef,
  $use_stderr              = undef,
  $log_facility            = undef,
  $manage_service          = true,
  $enabled                 = true,
  $purge_config            = false,
  $cert_file               = $::os_service_default,
  $key_file                = $::os_service_default,
  $ca_file                 = $::os_service_default,
  $os_region_name          = $::os_service_default,
  $enable_v1_registry      = false,
) inherits glance {

  include ::glance::deps
  include ::glance::registry::logging
  include ::glance::registry::db

  if ( $glance::params::api_package_name != $glance::params::registry_package_name ) {
    ensure_packages( 'glance-registry',
      {
        ensure => $package_ensure,
        tag    => ['openstack', 'glance-package'],
      }
    )
  }

  resources { 'glance_registry_config':
    purge => $purge_config
  }

  glance_registry_config {
    'DEFAULT/workers':                value => $workers;
    'DEFAULT/bind_host':              value => $bind_host;
    'DEFAULT/bind_port':              value => $bind_port;
    'DEFAULT/enable_v1_registry':     value => $enable_v1_registry;
    'glance_store/os_region_name':    value => $os_region_name;
  }

  # Set the pipeline, it is allowed to be blank
  if $pipeline != '' {
    validate_re($pipeline, '^(\w+([+]\w+)*)*$')
    glance_registry_config {
      'paste_deploy/flavor':
        ensure => present,
        value  => $pipeline,
    }
  } else {
    glance_registry_config { 'paste_deploy/flavor': ensure => absent }
  }

  # keystone config
  if $auth_strategy == 'keystone' {
    include ::glance::registry::authtoken
  }

  # SSL Options
  glance_registry_config {
    'DEFAULT/cert_file': value => $cert_file;
    'DEFAULT/key_file':  value => $key_file;
    'DEFAULT/ca_file':   value => $ca_file;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  } else {
    warning('Execution of db_sync does not depend on $manage_service or $enabled anymore. Please use sync_db instead.')
  }

  service { 'glance-registry':
    ensure     => $service_ensure,
    name       => $::glance::params::registry_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'glance-service',
  }

}
