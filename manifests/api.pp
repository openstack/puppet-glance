#
# == Parameters
#
#
#  * keystone_password Password used to authemn
#
#  * verbose - rather to log the glance api service at verbose level.
#  Optional. Default: false
#
#  * debug - rather to log the glance api service at debug level.
#  Optional. Default: false
#
#  * bind_host - The address of the host to bind to.
#  Optional. Default: 0.0.0.0
#
#  * bind_port - The port the server should bind to.
#  Optional. Default: 9292
#
#  * registry_host - The address used to connecto to the registy service.
#  Optional. Default:
#
#  * registry_port - The port of the Glance registry service.
#  Optional. Default: 9191
#
#  * log_file - The path of file used for logging
#  Optional. Default: /var/log/glance/api.log
#
#  * auth_type - Type is authorization being used. Optional. Defaults to 'keystone'
#  * auth_host - Host running auth service. Optional. Defaults to '127.0.0.1'.
#  * auth_port - Port to use for auth service on auth_host. Optional. Defaults to '35357'.
#  * auth_admin_prefix - (optional) path part of the auth url.
#    This allow admin auth URIs like http://auth_host:35357/keystone/admin.
#    (where '/keystone/admin' is auth_admin_prefix)
#    Defaults to false for empty. If defined, should be a string with a leading '/' and no trailing '/'.
#  * auth_protocol - Protocol to use for auth. Optional. Defaults to 'http'.
#  * auth_uri - Complete public Identity API endpoint.
#  * keystone_tenant - tenant to authenticate to. Optioal. Defaults to services.
#  * keystone_user User to authenticate as with keystone Optional. Defaults to glance.
#  * enabled  Whether to enable services. Optional. Defaults to true.
#  * sql_idle_timeout
#  * sql_connection db conection.
#  * use_syslog - Use syslog for logging.
#  * log_facility - Syslog facility to receive log lines.
#
class glance::api(
  $keystone_password,
  $verbose           = false,
  $debug             = false,
  $bind_host         = '0.0.0.0',
  $bind_port         = '9292',
  $backlog           = '4096',
  $workers           = $::processorcount,
  $log_file          = '/var/log/glance/api.log',
  $registry_host     = '0.0.0.0',
  $registry_port     = '9191',
  $auth_type         = 'keystone',
  $auth_host         = '127.0.0.1',
  $auth_url          = 'http://localhost:5000/v2.0',
  $auth_port         = '35357',
  $auth_uri          = false,
  $auth_admin_prefix = false,
  $auth_protocol     = 'http',
  $pipeline          = 'keystone+cachemanagement',
  $keystone_tenant   = 'services',
  $keystone_user     = 'glance',
  $enabled           = true,
  $sql_idle_timeout  = '3600',
  $sql_connection    = 'sqlite:///var/lib/glance/glance.sqlite',
  $use_syslog        = false,
  $log_facility      = 'LOG_USER',
) inherits glance {

  require keystone::python

  validate_re($sql_connection, '(sqlite|mysql|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  Package['glance'] -> Glance_api_config<||>
  Package['glance'] -> Glance_cache_config<||>
  # adding all of this stuff b/c it devstack says glance-api uses the
  # db now
  Glance_api_config<||>   ~> Exec<| title == 'glance-manage db_sync' |>
  Glance_cache_config<||> ~> Exec<| title == 'glance-manage db_sync' |>
  Exec<| title == 'glance-manage db_sync' |> ~> Service['glance-api']
  Glance_api_config<||>   ~> Service['glance-api']
  Glance_cache_config<||> ~> Service['glance-api']

  File {
    ensure  => present,
    owner   => 'glance',
    group   => 'glance',
    mode    => '0640',
    notify  => Service['glance-api'],
    require => Class['glance'],
  }

  if($sql_connection =~ /mysql:\/\/\S+:\S+@\S+\/\S+/) {
    require 'mysql::python'
  } elsif($sql_connection =~ /postgresql:\/\/\S+:\S+@\S+\/\S+/) {

  } elsif($sql_connection =~ /sqlite:\/\//) {

  } else {
    fail("Invalid db connection ${sql_connection}")
  }

  # basic service config
  glance_api_config {
    'DEFAULT/verbose':   value => $verbose;
    'DEFAULT/debug':     value => $debug;
    'DEFAULT/bind_host': value => $bind_host;
    'DEFAULT/bind_port': value => $bind_port;
    'DEFAULT/backlog':   value => $backlog;
    'DEFAULT/workers':   value => $workers;
    'DEFAULT/log_file':  value => $log_file;
  }

  glance_cache_config {
    'DEFAULT/verbose':   value => $verbose;
    'DEFAULT/debug':     value => $debug;
  }

  # configure api service to connect registry service
  glance_api_config {
    'DEFAULT/registry_host': value => $registry_host;
    'DEFAULT/registry_port': value => $registry_port;
  }

  glance_cache_config {
    'DEFAULT/registry_host': value => $registry_host;
    'DEFAULT/registry_port': value => $registry_port;
  }

  # db connection config
  # I do not believe this was required in Essex.
  # Does the API server now need to connect to the DB?
  # TODO figure out if I need this...
  glance_api_config {
    'DEFAULT/sql_connection':   value => $sql_connection;
    'DEFAULT/sql_idle_timeout': value => $sql_idle_timeout;
  }

  if $auth_uri {
    glance_api_config { 'keystone_authtoken/auth_uri': value => $auth_uri; }
  } else {
    glance_api_config { 'keystone_authtoken/auth_uri': value => "${auth_protocol}://${auth_host}:5000/"; }
  }

  # auth config
  glance_api_config {
    'keystone_authtoken/auth_host':     value => $auth_host;
    'keystone_authtoken/auth_port':     value => $auth_port;
    'keystone_authtoken/auth_protocol': value => $auth_protocol;
  }

  if $auth_admin_prefix {
    validate_re($auth_admin_prefix, '^(/.+[^/])?$')
    glance_api_config {
      'keystone_authtoken/auth_admin_prefix': value => $auth_admin_prefix;
    }
  } else {
    glance_api_config {
      'keystone_authtoken/auth_admin_prefix': ensure => absent;
    }
  }

  # Set the pipeline, it is allowed to be blank
  if $pipeline != '' {
    validate_re($pipeline, '^(\w+([+]\w+)*)*$')
    glance_api_config {
      'paste_deploy/flavor':
        ensure => present,
        value  => $pipeline,
    }
  } else {
    glance_api_config { 'paste_deploy/flavor': ensure => absent }
  }

  # keystone config
  if $auth_type == 'keystone' {
    glance_api_config {
      'keystone_authtoken/admin_tenant_name': value => $keystone_tenant;
      'keystone_authtoken/admin_user'       : value => $keystone_user;
      'keystone_authtoken/admin_password'   : value => $keystone_password;
    }
    glance_cache_config {
      'DEFAULT/auth_url'         : value => $auth_url;
      'DEFAULT/admin_tenant_name': value => $keystone_tenant;
      'DEFAULT/admin_user'       : value => $keystone_user;
      'DEFAULT/admin_password'   : value => $keystone_password;
    }
  }

  # Syslog
  if $use_syslog {
    glance_api_config {
      'DEFAULT/use_syslog'          : value => true;
      'DEFAULT/syslog_log_facility' : value => $log_facility;
    }
  } else {
    glance_api_config {
      'DEFAULT/use_syslog': value => false;
    }
  }

  file { ['/etc/glance/glance-api.conf',
          '/etc/glance/glance-api-paste.ini',
          '/etc/glance/glance-cache.conf']:
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'glance-api':
    ensure     => $service_ensure,
    name       => $::glance::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
