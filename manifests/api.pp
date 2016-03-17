# == Class glance::api
#
# Configure API service in glance
#
# == Parameters
#
# [*keystone_password*]
#   (required) Password used to authentication.
#
# [*package_ensure*]
#   (optional) Ensure state for package. On RedHat platforms this
#   setting is ignored and the setting from the glance class is used
#   because there is only one glance package. Defaults to 'present'.
#
# [*verbose*]
#   (optional) Rather to log the glance api service at verbose level.
#   Default: undef
#
# [*debug*]
#   (optional) Rather to log the glance api service at debug level.
#   Default: undef
#
# [*bind_host*]
#   (optional) The address of the host to bind to.
#   Default: 0.0.0.0
#
# [*bind_port*]
#   (optional) The port the server should bind to.
#   Default: 9292
#
# [*backlog*]
#   (optional) Backlog requests when creating socket
#   Default: 4096
#
# [*workers*]
#   (optional) Number of Glance API worker processes to start
#   Default: $::processorcount
#
# [*log_file*]
#   (optional) The path of file used for logging
#   If set to boolean false, it will not log to any file.
#   Default: undef
#
#  [*log_dir*]
#    (optional) directory to which glance logs are sent.
#    If set to boolean false, it will not log to any directory.
#    Defaults to undef
#
# [*registry_host*]
#   (optional) The address used to connect to the registry service.
#   Default: 0.0.0.0
#
# [*registry_port*]
#   (optional) The port of the Glance registry service.
#   Default: 9191
#
# [*registry_client_protocol*]
#   (optional) The protocol of the Glance registry service.
#   Default: http
#
# [*scrub_time*]
#   (optional) The amount of time in seconds to delay before performing a delete.
#   Defaults to $::os_service_default.
#
# [*delayed_delete*]
#   (optional) Turn on/off delayed delete.
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (optional) Type is authorization being used.
#   Defaults to 'keystone'
#
# [*auth_region*]
#   (optional) The region for the authentication service.
#   If "use_user_token" is not in effect and using keystone auth,
#   then region name can be specified.
#   Defaults to $::os_service_default.
#
# [*auth_uri*]
#   (optional) Complete public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000/'.
#
# [*identity_uri*]
#   (optional) Complete admin Identity API endpoint.
#   Defaults to 'http://127.0.0.1:35357/'.
#
# [*pipeline*]
#   (optional) Partial name of a pipeline in your paste configuration file with the
#   service name removed.
#   Defaults to 'keystone'.
#
# [*keystone_tenant*]
#   (optional) Tenant to authenticate to.
#   Defaults to services.
#
# [*keystone_user*]
#   (optional) User to authenticate as with keystone.
#   Defaults to 'glance'.
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*database_connection*]
#   (optional) Connection url to connect to nova database.
#   Defaults to undef
#
# [*database_idle_timeout*]
#   (optional) Timeout before idle db connections are reaped.
#   Defaults to undef
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to undef.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to undef.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to undef.
#
# [*image_cache_max_size*]
#   (optional) The upper limit (the maximum size of accumulated cache in bytes) beyond which pruner,
#   if running, starts cleaning the images cache.
#   Defaults to $::os_service_default.
#
# [*image_cache_stall_time*]
#   (optional) The amount of time to let an image remain in the cache without being accessed.
#   Defaults to $::os_service_default.
#
# [*use_syslog*]
#   (optional) Use syslog for logging.
#   Defaults to undef
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef
#
# [*log_facility*]
#   (optional) Syslog facility to receive log lines.
#   Defaults to undef
#
# [*show_image_direct_url*]
#   (optional) Expose image location to trusted clients.
#   Defaults to false.
#
# [*show_multiple_locations*]
#   (optional) Whether to include the backend image locations in image
#    properties.
#   Defaults to $::os_service_default.
#
# [*location_strategy*]
#   (optional) Strategy used to determine the image location order.
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the api config.
#   Defaults to false.
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
# [*registry_client_cert_file*]
#   (optinal) The path to the cert file to use in SSL connections to the
#   registry server.
#   Defaults to $::os_service_default
#
# [*registry_client_key_file*]
#   (optinal) The path to the private key file to use in SSL connections to the
#   registry server.
#   Defaults to $::os_service_default
#
# [*registry_client_ca_file*]
#   (optinal) The path to the CA certificate file to use in SSL connections to the
#   registry server.
#   Defaults to $::os_service_default
#
# [*stores*]
#   (optional) List of which store classes and store class locations are
#    currently known to glance at startup.
#    Defaults to false.
#    Example: ['file','http']
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
# [*image_cache_dir*]
#   (optional) Base directory that the Image Cache uses.
#    Defaults to '/var/lib/glance/image-cache'.
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*signing_dir*]
#   (optional) Directory used to cache files related to PKI tokens.
#   Defaults to $::os_service_default.
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left undefined,
#   tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
# [*token_cache_time*]
#   (optional) In order to prevent excessive effort spent validating tokens,
#   the middleware caches previously-seen tokens for a configurable duration (in seconds).
#   Set to -1 to disable caching completely.
#   Defaults to $::os_service_default.
#
# [*validate*]
#   (optional) Whether to validate the service is working after any service refreshes
#   Defaults to false
#
# [*validation_options*]
#   (optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Default command list images.
#   Require validate set at True.
#   Example:
#   glance::api::validation_options:
#     glance-api:
#       command: check_glance-api.py
#       path: /usr/bin:/bin:/usr/sbin:/sbin
#       provider: shell
#       tries: 5
#       try_sleep: 10
#   Defaults to {}
#
#  === deprecated parameters:
#
# [*known_stores*]
#   (optional) DEPRECATED List of which store classes and store class
#   locations are currently known to glance at startup. This parameter
#   should be removed in the N release.
#   Defaults to false.
#   Example: ['file','http']
#
class glance::api(
  $keystone_password,
  $package_ensure            = 'present',
  $verbose                   = undef,
  $debug                     = undef,
  $bind_host                 = '0.0.0.0',
  $bind_port                 = '9292',
  $backlog                   = '4096',
  $workers                   = $::processorcount,
  $log_file                  = undef,
  $log_dir                   = undef,
  $registry_host             = '0.0.0.0',
  $registry_port             = '9191',
  $registry_client_protocol  = 'http',
  $scrub_time                = $::os_service_default,
  $delayed_delete            = $::os_service_default,
  $auth_type                 = 'keystone',
  $auth_region               = $::os_service_default,
  $auth_uri                  = 'http://127.0.0.1:5000/',
  $identity_uri              = 'http://127.0.0.1:35357/',
  $memcached_servers         = $::os_service_default,
  $pipeline                  = 'keystone',
  $keystone_tenant           = 'services',
  $keystone_user             = 'glance',
  $manage_service            = true,
  $enabled                   = true,
  $use_syslog                = undef,
  $use_stderr                = undef,
  $log_facility              = undef,
  $show_image_direct_url     = false,
  $show_multiple_locations   = $::os_service_default,
  $location_strategy         = $::os_service_default,
  $purge_config              = false,
  $cert_file                 = $::os_service_default,
  $key_file                  = $::os_service_default,
  $ca_file                   = $::os_service_default,
  $registry_client_cert_file = $::os_service_default,
  $registry_client_key_file  = $::os_service_default,
  $registry_client_ca_file   = $::os_service_default,
  $stores                    = false,
  $default_store             = undef,
  $multi_store               = false,
  $database_connection       = undef,
  $database_idle_timeout     = undef,
  $database_min_pool_size    = undef,
  $database_max_pool_size    = undef,
  $database_max_retries      = undef,
  $database_retry_interval   = undef,
  $database_max_overflow     = undef,
  $image_cache_max_size      = $::os_service_default,
  $image_cache_stall_time    = $::os_service_default,
  $image_cache_dir           = '/var/lib/glance/image-cache',
  $os_region_name            = 'RegionOne',
  $signing_dir               = $::os_service_default,
  $token_cache_time          = $::os_service_default,
  $validate                  = false,
  $validation_options        = {},
  # DEPRECATED PARAMETERS
  $known_stores              = false,
) inherits glance {

  include ::glance::policy
  include ::glance::api::db
  include ::glance::api::logging
  include ::glance::cache::logging

  if ( $glance::params::api_package_name != $glance::params::registry_package_name ) {
    ensure_packages('glance-api',
      {
        ensure => $package_ensure,
        tag    => ['openstack', 'glance-package'],
      }
    )
  }

  Package[$glance::params::api_package_name] -> Class['glance::policy']

  # adding all of this stuff b/c it devstack says glance-api uses the
  # db now
  Glance_api_config<||>   ~> Service['glance-api']
  Glance_cache_config<||> ~> Service['glance-api']
  Class['glance::policy'] ~> Service['glance-api']
  Service['glance-api']   ~> Glance_image<||>

  # basic service config
  glance_api_config {
    'DEFAULT/bind_host':               value => $bind_host;
    'DEFAULT/bind_port':               value => $bind_port;
    'DEFAULT/backlog':                 value => $backlog;
    'DEFAULT/workers':                 value => $workers;
    'DEFAULT/show_image_direct_url':   value => $show_image_direct_url;
    'DEFAULT/show_multiple_locations': value => $show_multiple_locations;
    'DEFAULT/location_strategy':       value => $location_strategy;
    'DEFAULT/scrub_time':              value => $scrub_time;
    'DEFAULT/delayed_delete':          value => $delayed_delete;
    'DEFAULT/image_cache_dir':         value => $image_cache_dir;
    'DEFAULT/auth_region':             value => $auth_region;
    'glance_store/os_region_name':     value => $os_region_name;
  }

  # stores config
  if $stores and $known_stores {
    fail('known_stores and stores cannot both be assigned values')
  } elsif $stores {
    $stores_real = $stores
  } elsif $known_stores {
    warning('The known_stores parameter is deprecated, use stores instead')
    $stores_real = $known_stores
  }
  if $default_store {
    $default_store_real = $default_store
  }
  # determine value for glance_store/stores
  if !empty($stores_real) {
    if size(any2array($stores_real)) > 1 {
      $final_stores_real = join($stores_real, ',')
    } else {
      $final_stores_real = $stores_real[0]
    }
    if !$default_store_real {
      # set default store based on provided stores when it isn't explicitly set
      warning("default_store not provided, it will be automatically set to ${stores_real[0]}")
      $default_store_real = $stores_real[0]
    }
  } elsif $default_store_real {
    # set stores based on default_store if only default_store is provided
    $final_stores_real = $default_store
  } else {
    warning('Glance-api is being provisioned without any stores configured')
  }

  if $default_store_real and $multi_store {
    glance_api_config {
      'glance_store/default_store': value => $default_store_real;
    }
  } elsif $multi_store {
    glance_api_config {
      'glance_store/default_store': ensure => absent;
    }
  }

  if $final_stores_real {
    glance_api_config {
      'glance_store/stores': value => $final_stores_real;
    }
  } else {
    glance_api_config {
      'glance_store/stores': ensure => absent;
    }
  }

  glance_cache_config {
    'DEFAULT/image_cache_stall_time': value => $image_cache_stall_time;
    'DEFAULT/image_cache_max_size':   value => $image_cache_max_size;
    'glance_store/os_region_name':    value => $os_region_name;
  }

  $registry_host_real = normalize_ip_for_uri($registry_host)
  # configure api service to connect registry service
  glance_api_config {
    'DEFAULT/registry_host':            value => $registry_host_real;
    'DEFAULT/registry_port':            value => $registry_port;
    'DEFAULT/registry_client_protocol': value => $registry_client_protocol;
  }

  glance_cache_config {
    'DEFAULT/registry_host': value => $registry_host;
    'DEFAULT/registry_port': value => $registry_port;
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
      'keystone_authtoken/admin_user':        value => $keystone_user;
      'keystone_authtoken/admin_password':    value => $keystone_password, secret => true;
      'keystone_authtoken/token_cache_time':  value => $token_cache_time;
      'keystone_authtoken/signing_dir':       value => $signing_dir;
      'keystone_authtoken/auth_uri':          value => $auth_uri;
      'keystone_authtoken/identity_uri':      value => $identity_uri;
      'keystone_authtoken/memcached_servers': value => join(any2array($memcached_servers), ',');
    }
    glance_cache_config {
      'DEFAULT/auth_url'         : value => $auth_uri;
      'DEFAULT/admin_tenant_name': value => $keystone_tenant;
      'DEFAULT/admin_user'       : value => $keystone_user;
      'DEFAULT/admin_password'   : value => $keystone_password, secret => true;
    }
  }

  # SSL Options
  glance_api_config {
    'DEFAULT/cert_file':                 value => $cert_file;
    'DEFAULT/key_file' :                 value => $key_file;
    'DEFAULT/ca_file'  :                 value => $ca_file;
    'DEFAULT/registry_client_ca_file':   value => $registry_client_ca_file;
    'DEFAULT/registry_client_cert_file': value => $registry_client_cert_file;
    'DEFAULT/registry_client_key_file':  value => $registry_client_key_file;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'glance-api':
    ensure     => $service_ensure,
    name       => $::glance::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'glance-service',
  }

  if $validate {
    $defaults = {
      'glance-api' => {
        'command'  => "glance --os-auth-url ${auth_uri} --os-tenant-name ${keystone_tenant} --os-username ${keystone_user} --os-password ${keystone_password} image-list",
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[glance-api]'})
  }

}
