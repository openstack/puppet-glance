# == Class: glance::registry
#
# Installs and configures glance-registry
#
# === Parameters
#
#  [*keystone_password*]
#    (required) The keystone password for administrative user
#
#  [*package_ensure*]
#    (optional) Ensure state for package. Defaults to 'present'.  On RedHat
#    platforms this setting is ignored and the setting from the glance class is
#    used because there is only one glance package.
#
#  [*verbose*]
#    (optional) Enable verbose logs (true|false). Defaults to undef.
#
#  [*debug*]
#    (optional) Enable debug logs (true|false). Defaults to undef.
#
#  [*bind_host*]
#    (optional) The address of the host to bind to. Defaults to '0.0.0.0'.
#
#  [*bind_port*]
#    (optional) The port the server should bind to. Defaults to '9191'.
#
#  [*workers*]
#    (optional) The number of child process workers that will be
#    created to service Registry requests.
#    Defaults to: $::processorcount
#
#  [*log_file*]
#    (optional) Log file for glance-registry.
#    If set to boolean false, it will not log to any file.
#    Defaults to undef.
#
#  [*log_dir*]
#    (optional) directory to which glance logs are sent.
#    If set to boolean false, it will not log to any directory.
#    Defaults to undef.
#
#  [*database_connection*]
#    (optional) Connection url to connect to nova database.
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
#  [*auth_type*]
#    (optional) Authentication type. Defaults to 'keystone'.
#
#  [*auth_uri*]
#    (optional) Complete public Identity API endpoint.
#    Defaults to 'http://127.0.0.1:5000/'.
#
#  [*identity_uri*]
#    (optional) Complete admin Identity API endpoint.
#    Defaults to 'http://127.0.0.1:35357/'.
#
#  [*keystone_tenant*]
#    (optional) administrative tenant name to connect to keystone.
#    Defaults to 'services'.
#
#  [*keystone_user*]
#    (optional) administrative user name to connect to keystone.
#    Defaults to 'glance'.
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
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting registry server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true
#
#  [*os_region_name*]
#    (optional) Sets the keystone region to use.
#    Defaults to $::os_service_default.
#
#  [*signing_dir*]
#    Directory used to cache files related to PKI tokens.
#    Defaults to $::os_service_default.
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left undefined,
#   tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
#  [*token_cache_time*]
#    In order to prevent excessive effort spent validating tokens,
#    the middleware caches previously-seen tokens for a configurable duration (in seconds).
#    Set to -1 to disable caching completely.
#    Defaults to $::os_service_default.
#
class glance::registry(
  $keystone_password,
  $package_ensure          = 'present',
  $verbose                 = undef,
  $debug                   = undef,
  $bind_host               = '0.0.0.0',
  $bind_port               = '9191',
  $workers                 = $::processorcount,
  $log_file                = undef,
  $log_dir                 = undef,
  $database_connection     = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
  $auth_type               = 'keystone',
  $auth_uri                = 'http://127.0.0.1:5000/',
  $identity_uri            = 'http://127.0.0.1:35357/',
  $keystone_tenant         = 'services',
  $keystone_user           = 'glance',
  $pipeline                = 'keystone',
  $use_syslog              = undef,
  $use_stderr              = undef,
  $log_facility            = undef,
  $manage_service          = true,
  $enabled                 = true,
  $purge_config            = false,
  $cert_file               = false,
  $key_file                = false,
  $ca_file                 = false,
  $sync_db                 = true,
  $os_region_name          = $::os_service_default,
  $signing_dir             = $::os_service_default,
  $memcached_servers       = $::os_service_default,
  $token_cache_time        = $::os_service_default,
) inherits glance {

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

  Glance_registry_config<||> ~> Service['glance-registry']

  glance_registry_config {
    'DEFAULT/workers':                value => $workers;
    'DEFAULT/bind_host':              value => $bind_host;
    'DEFAULT/bind_port':              value => $bind_port;
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
  if $auth_type == 'keystone' {
    glance_registry_config {
      'keystone_authtoken/admin_tenant_name': value => $keystone_tenant;
      'keystone_authtoken/admin_user':        value => $keystone_user;
      'keystone_authtoken/admin_password':    value => $keystone_password, secret => true;
      'keystone_authtoken/token_cache_time':  value => $token_cache_time;
      'keystone_authtoken/signing_dir':       value => $signing_dir;
      'keystone_authtoken/auth_uri':          value => $auth_uri;
      'keystone_authtoken/identity_uri':      value => $identity_uri;
      'keystone_authtoken/memcached_servers': value => join(any2array($memcached_servers), ',');
    }
  }

  # SSL Options
  if $cert_file {
    glance_registry_config {
      'DEFAULT/cert_file' : value => $cert_file;
    }
  } else {
    glance_registry_config {
      'DEFAULT/cert_file': ensure => absent;
    }
  }
  if $key_file {
    glance_registry_config {
      'DEFAULT/key_file'  : value => $key_file;
    }
  } else {
    glance_registry_config {
      'DEFAULT/key_file': ensure => absent;
    }
  }
  if $ca_file {
    glance_registry_config {
      'DEFAULT/ca_file'   : value => $ca_file;
    }
  } else {
    glance_registry_config {
      'DEFAULT/ca_file': ensure => absent;
    }
  }

  if $sync_db {
    include ::glance::db::sync
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
    require    => Class['glance'],
    tag        => 'glance-service',
  }

}
