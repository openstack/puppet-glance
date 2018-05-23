# == Class glance::api
#
# Configure API service in glance
#
# == Parameters
#
# [*package_ensure*]
#   (optional) Ensure state for package. On RedHat platforms this
#   setting is ignored and the setting from the glance class is used
#   because there is only one glance package. Defaults to 'present'.
#
# [*debug*]
#   (optional) Rather to log the glance api service at debug level.
#   Default: undef
#
# [*bind_host*]
#   (optional) The address of the host to bind to.
#   Default: $::os_service_default.
#
# [*bind_port*]
#   (optional) The port the server should bind to.
#   Default: 9292
#
# [*backlog*]
#   (optional) Backlog requests when creating socket
#   Default: $::os_service_default.
#
# [*workers*]
#   (optional) Number of Glance API worker processes to start
#   Default: $::os_workers.
#
# [*log_file*]
#   (optional) The path of file used for logging
#   If set to $::os_service_default, it will not log to any file.
#   Default: undef
#
#  [*log_dir*]
#    (optional) directory to which glance logs are sent.
#    If set to $::os_service_default, it will not log to any directory.
#    Defaults to undef
#
# [*registry_host*]
#   (optional) The address used to connect to the registry service.
#   Default: 0.0.0.0
#
# [*registry_port*]
#   (optional) The port of the Glance registry service.
#   Default: $::os_service_default.
#
# [*registry_client_protocol*]
#   (optional) The protocol of the Glance registry service.
#   Default: $::os_service_default.
#
# [*scrub_time*]
#   (optional) The amount of time in seconds to delay before performing a delete.
#   Defaults to $::os_service_default.
#
# [*delayed_delete*]
#   (optional) Turn on/off delayed delete.
#   Defaults to $::os_service_default.
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
# [*database_connection*]
#   (optional) Connection url to connect to glance database.
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
#   Defaults to $::os_service_default.
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
# [*enabled_import_methods*]
#   (optional) The list of enabled Image Import Methods.
#    Defaults to $::os_service_default.
#
# [*node_staging_uri*]
# (optional) The URL provides location where the temporary data will be
#  stored when image import method is set to 'glance-direct'
#  Defaults to $::os_service_default.
#
# [*image_member_quota*]
#   (optional) The maximum number of image members allowed per image.
#    Defaults to $::os_service_default
#
# [*task_time_to_live*]
#   (optional) Time in hours for which a task lives after.
#   Defaults to $::os_service_default
#
# [*task_executor*]
#   (optional) Task executor to be used t orun task scripts.
#   Defaults to $::os_service_default
#
# [*task_work_dir*]
#   (optional) Absolute path to the work directory to use for asynchronous
#   task operations.
#   Defaults to $::os_service_default
#
# [*taskflow_engine_mode*]
#   (optional) Set the taskflow engine mode.
#   Allowed values: 'parallel', 'serial'.
#   Defaults to $::os_service_default
#
# [*taskflow_max_workers*]
#   (optional) Integer value to limit the number of taskflow workers. Only
#   relevant if taskflow_engine_mode is 'parallel'.
#   Defaults to $::os_service_default
#
# [*conversion_format*]
#   (optional) Allow automatic image conversion.
#   Allowed values: 'qcow2', 'raw', 'vmdk', false.
#   Defaults to $::os_service_default (disabled)
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# [*enable_v1_api*]
#   (Optional) Enable or not Glance API v1.
#   If you enable this option, you'll get a deprecation warning in Glance
#   logs.  If enable_v2_api is set to True, glance::registry::enable_v1_registry
#   must be configured to True, since Registry is required in API v1.
#   Defaults to false.
#
# [*enable_v2_api*]
#   (Optional) Enable or not Glance API v2.
#   Defaults to $::os_service_default.
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true
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
# [*limit_param_default*]
#   (optional) Default value for the number of items returned by a request if not
#   specified explicitly in the request (integer value)
#   Default: $::os_service_default.
#
# [*api_limit_max*]
#   (optional) Maximum number of results that could be returned by a request
#   Default: $::os_service_default.
#
# [*keymgr_backend*]
#   (optional) Key Manager service class.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to undef.
#
# [*keymgr_encryption_api_url*]
#   (optional) Key Manager service URL
#   Example of valid value: https://localhost:9311/v1
#   Defaults to undef
#
# [*keymgr_encryption_auth_url*]
#   (optional) Auth URL for keymgr authentication. Should be in format
#   http://auth_url:5000/v3
#   Defaults to undef
#
class glance::api(
  $package_ensure                       = 'present',
  $debug                                = undef,
  $bind_host                            = $::os_service_default,
  $bind_port                            = '9292',
  $backlog                              = $::os_service_default,
  $workers                              = $::os_workers,
  $log_file                             = undef,
  $log_dir                              = undef,
  $registry_host                        = '0.0.0.0',
  $registry_port                        = $::os_service_default,
  $registry_client_protocol             = $::os_service_default,
  $scrub_time                           = $::os_service_default,
  $delayed_delete                       = $::os_service_default,
  $auth_strategy                        = 'keystone',
  $pipeline                             = 'keystone',
  $manage_service                       = true,
  $enabled                              = true,
  $use_syslog                           = undef,
  $use_stderr                           = undef,
  $log_facility                         = undef,
  $show_image_direct_url                = $::os_service_default,
  $show_multiple_locations              = $::os_service_default,
  $location_strategy                    = $::os_service_default,
  $purge_config                         = false,
  $cert_file                            = $::os_service_default,
  $key_file                             = $::os_service_default,
  $ca_file                              = $::os_service_default,
  $registry_client_cert_file            = $::os_service_default,
  $registry_client_key_file             = $::os_service_default,
  $registry_client_ca_file              = $::os_service_default,
  $stores                               = false,
  $default_store                        = undef,
  $multi_store                          = false,
  $database_connection                  = undef,
  $database_idle_timeout                = undef,
  $database_min_pool_size               = undef,
  $database_max_pool_size               = undef,
  $database_max_retries                 = undef,
  $database_retry_interval              = undef,
  $database_max_overflow                = undef,
  $image_cache_max_size                 = $::os_service_default,
  $image_cache_stall_time               = $::os_service_default,
  $image_cache_dir                      = '/var/lib/glance/image-cache',
  $enabled_import_methods               = $::os_service_default,
  $node_staging_uri                     = $::os_service_default,
  $image_member_quota                   = $::os_service_default,
  $task_time_to_live                    = $::os_service_default,
  $task_executor                        = $::os_service_default,
  $task_work_dir                        = $::os_service_default,
  $taskflow_engine_mode                 = $::os_service_default,
  $taskflow_max_workers                 = $::os_service_default,
  $conversion_format                    = $::os_service_default,
  $os_region_name                       = 'RegionOne',
  $enable_proxy_headers_parsing         = $::os_service_default,
  $enable_v1_api                        = false,
  $enable_v2_api                        = $::os_service_default,
  $sync_db                              = true,
  $validate                             = false,
  $validation_options                   = {},
  $limit_param_default                  = $::os_service_default,
  $api_limit_max                        = $::os_service_default,
  $keymgr_backend                       = undef,
  $keymgr_encryption_api_url            = undef,
  $keymgr_encryption_auth_url           = undef,
) inherits glance {

  include ::glance::deps
  include ::glance::policy
  include ::glance::api::db
  include ::glance::api::logging
  include ::glance::cache::logging

  if $sync_db {
    include ::glance::db::sync
    include ::glance::db::metadefs
  }

  if ( $glance::params::api_package_name != $glance::params::registry_package_name ) {
    ensure_packages('glance-api',
      {
        ensure => $package_ensure,
        tag    => ['openstack', 'glance-package'],
      }
    )
  }

  if $enabled_import_methods != $::os_service_default {
    # This option is a ListOpt that requires explicit brackets.
    $enabled_import_methods_real = sprintf('[%s]', join(any2array($enabled_import_methods), ','))
  } else {
    $enabled_import_methods_real = $enabled_import_methods
  }

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
    'DEFAULT/enabled_import_methods':  value => $enabled_import_methods_real;
    'DEFAULT/node_staging_uri':        value => $node_staging_uri;
    'DEFAULT/image_member_quota':      value => $image_member_quota;
    'DEFAULT/enable_v1_api':           value => $enable_v1_api;
    'DEFAULT/enable_v2_api':           value => $enable_v2_api;
    'DEFAULT/limit_param_default':     value => $limit_param_default;
    'DEFAULT/api_limit_max':           value => $api_limit_max;
    'glance_store/os_region_name':     value => $os_region_name;
  }

  # task/taskflow_executor config.
  glance_api_config {
    'task/task_time_to_live':              value => $task_time_to_live;
    'task/task_executor':                  value => $task_executor;
    'task/work_dir':                       value => $task_work_dir;
    'taskflow_executor/engine_mode':       value => $taskflow_engine_mode;
    'taskflow_executor/max_workers':       value => $taskflow_max_workers;
    'taskflow_executor/conversion_format': value => $conversion_format,
  }

  if $default_store {
    $default_store_real = $default_store
  }
  if ($stores and !empty($stores)) {
    # determine value for glance_store/stores
    if size(any2array($stores)) > 1 {
      $stores_real = join($stores, ',')
    } else {
      $stores_real = $stores[0]
    }
    if !$default_store_real {
      # set default store based on provided stores when it isn't explicitly set
      warning("default_store not provided, it will be automatically set to ${stores[0]}")
      $default_store_real = $stores[0]
    }
  } elsif $default_store_real {
    # set stores based on default_store if only default_store is provided
    $stores_real = $default_store
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

  if $stores_real {
    glance_api_config {
      'glance_store/stores': value => $stores_real;
    }
  } else {
    glance_api_config {
      'glance_store/stores': ensure => absent;
    }
  }

  resources { 'glance_api_config':
    purge => $purge_config,
  }

  glance_cache_config {
    'DEFAULT/image_cache_stall_time': value => $image_cache_stall_time;
    'DEFAULT/image_cache_max_size':   value => $image_cache_max_size;
    'glance_store/os_region_name':    value => $os_region_name;
  }

  # configure api service to connect registry service
  glance_api_config {
    'DEFAULT/registry_host':            value => $registry_host;
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
  if $auth_strategy == 'keystone' {
    include ::glance::api::authtoken
  }

  oslo::middleware { 'glance_api_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
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

  if $keymgr_backend {
    glance_api_config {
      'key_manager/backend':        value => $keymgr_backend;
      'barbican/barbican_endpoint': value => $keymgr_encryption_api_url;
      'barbican/auth_endpoint':     value => $keymgr_encryption_auth_url;
    }
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
    $keystone_project_name = $::glance::api::authtoken::project_name
    $keystone_username     = $::glance::api::authtoken::username
    $keystone_password     = $::glance::api::authtoken::password
    # TODO(tobasco): Remove pick when auth_uri is removed.
    $auth_uri              = pick($::glance::api::authtoken::auth_uri, $::glance::api::authtoken::www_authenticate_uri)
    $defaults = {
      'glance-api' => {
        # lint:ignore:140chars
        'command'  => "glance --os-auth-url ${auth_uri} --os-project-name ${keystone_project_name} --os-username ${keystone_username} --os-password ${keystone_password} image-list",
        # lint:endignore
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[glance-api]'})
  }

}
