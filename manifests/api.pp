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
# [*container_formats*]
#   (optional) List of allowed values for an image container_format attributes
#   Defaults to $::os_service_default.
#
# [*disk_formats*]
#   (optional) List of allowed values for an image disk_format attribute.
#   Defaults to $::os_service_default.
#
# [*cache_prefetcher_interval*]
#   (optional) The interval in seconds to run periodic job 'cache_images'
#   Defaults to $::os_service_default.
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
# [*image_import_plugins*]
#   (optional) (Array) List of enabled Image Import Plugins.
#   Defaults to $::os_service_default.
#
# [*image_conversion_output_format*]
#   (optional) Desired output format for image conversion plugin.
#   Defaults to $::os_service_default.
#
# [*inject_metadata_properties*]
#   (optional) Dictionary contains metadata properties to be injected in image.
#   Defaults to $::os_service_default.
#
# [*ignore_user_roles*]
#   (optional) List containing user roles. For example: [admin,member]
#   Defaults to $::os_service_default.
#
# [*show_image_direct_url*]
#   (optional) Expose image location to trusted clients.
#   Defaults to $::os_service_default.
#
# [*filesystem_store_metadata_file*]
#   (optional) The path to a file which contains the metadata to be returned
#    with any location associated with the filesystem store
#    properties.
#   Defaults to $::os_service_default.
#
# [*filesystem_store_file_perm*]
#   (optional) File access permissions for the image files.
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
# [*enabled_backends*]
#   (optional) List of Key:Value pairs of store identifier and store type.
#   Example: ['swift:swift', 'ceph1:ceph', 'ceph2:ceph']
#   Defaults to undef
#
# [*default_backend*]
#   (optional) The store identifier for the default backend in which data will
#   be stored. The value must be defined as one of the keys in the dict
#   defined by the enabled_backends.
#   Defaults to undef
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
# [*worker_self_reference_url*]
#   (optional) The self-reference URL by which other workers will get to know
#   how to contact the worker which has staged the image.
#   Defaults to $::os_service_default.
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
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
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
# DEPRECATED PARAMETERS
#
# [*stores*]
#   (optional) List of which store classes and store class locations are
#    currently known to glance at startup.
#    Defaults to undef
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
# [*show_multiple_locations*]
#   (optional) Whether to include the backend image locations in image
#    properties.
#   Defaults to undef
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to undef
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
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to undef.
#
class glance::api(
  $package_ensure                       = 'present',
  $bind_host                            = $::os_service_default,
  $bind_port                            = '9292',
  $backlog                              = $::os_service_default,
  $workers                              = $::os_workers,
  $scrub_time                           = $::os_service_default,
  $delayed_delete                       = $::os_service_default,
  $auth_strategy                        = 'keystone',
  $pipeline                             = 'keystone',
  $manage_service                       = true,
  $enabled                              = true,
  $show_image_direct_url                = $::os_service_default,
  $filesystem_store_metadata_file       = $::os_service_default,
  $filesystem_store_file_perm           = $::os_service_default,
  $location_strategy                    = $::os_service_default,
  $purge_config                         = false,
  $cert_file                            = $::os_service_default,
  $key_file                             = $::os_service_default,
  $ca_file                              = $::os_service_default,
  $enabled_backends                     = undef,
  $default_backend                      = undef,
  $container_formats                    = $::os_service_default,
  $disk_formats                         = $::os_service_default,
  $cache_prefetcher_interval            = $::os_service_default,
  $image_cache_max_size                 = $::os_service_default,
  $image_cache_stall_time               = $::os_service_default,
  $image_cache_dir                      = '/var/lib/glance/image-cache',
  $image_import_plugins                 = $::os_service_default,
  $inject_metadata_properties           = $::os_service_default,
  $ignore_user_roles                    = $::os_service_default,
  $image_conversion_output_format       = $::os_service_default,
  $enabled_import_methods               = $::os_service_default,
  $node_staging_uri                     = $::os_service_default,
  $worker_self_reference_url            = $::os_service_default,
  $image_member_quota                   = $::os_service_default,
  $task_time_to_live                    = $::os_service_default,
  $task_executor                        = $::os_service_default,
  $task_work_dir                        = $::os_service_default,
  $taskflow_engine_mode                 = $::os_service_default,
  $taskflow_max_workers                 = $::os_service_default,
  $conversion_format                    = $::os_service_default,
  $enable_proxy_headers_parsing         = $::os_service_default,
  $max_request_body_size                = $::os_service_default,
  $sync_db                              = true,
  $validate                             = false,
  $validation_options                   = {},
  $limit_param_default                  = $::os_service_default,
  $api_limit_max                        = $::os_service_default,
  $keymgr_backend                       = undef,
  $keymgr_encryption_api_url            = undef,
  $keymgr_encryption_auth_url           = undef,
  # DEPRECATED PARAMETERS
  $stores                               = undef,
  $default_store                        = undef,
  $multi_store                          = false,
  $show_multiple_locations              = undef,
  $database_min_pool_size               = undef,
  $os_region_name                       = undef,
  $database_connection                  = undef,
  $database_idle_timeout                = undef,
  $database_max_pool_size               = undef,
  $database_max_retries                 = undef,
  $database_retry_interval              = undef,
  $database_max_overflow                = undef,
) inherits glance {

  include glance::deps
  include glance::policy
  include glance::api::db

  if $os_region_name != undef {
    warning('glance::api::os_region_name is deprecated. Use \
cinder::backend::multistore::cinder::cinder_os_region_name instead.')
  }

  if $database_connection != undef {
    warning('The database_connection parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_connection instead')
  }

  if $database_idle_timeout != undef {
    warning('The database_idle_timeout parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_connection_recycle_time \
instead')
  }

  if $database_max_pool_size != undef {
    warning('The database_max_pool_size parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_max_pool_size instead')
  }

  if $database_max_retries!= undef {
    warning('The database_max_retries parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_max_retries instead')
  }

  if $database_retry_interval != undef {
    warning('The database_retry_interval parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_retry_interval instead')
  }

  if $database_max_overflow != undef {
    warning('The database_max_overflow parameter is deprecated and will be \
removed in a future realse. Use glance::api::db::database_max_overflow instead')
  }

  if $sync_db {
    include glance::db::sync
    include glance::db::metadefs
  }

  if ( $glance::params::api_package_name != undef ) {
    package { $::glance::params::api_package_name :
      ensure => $package_ensure,
      name   => $::glance::params::api_package_name,
      tag    => ['openstack', 'glance-package'],
    }
  }

  if $enabled_import_methods != $::os_service_default {
    # This option is a ListOpt that requires explicit brackets.
    $enabled_import_methods_real = sprintf('[%s]', join(any2array($enabled_import_methods), ','))
  } else {
    $enabled_import_methods_real = $enabled_import_methods
  }

  # basic service config
  glance_api_config {
    'DEFAULT/bind_host':                  value => $bind_host;
    'DEFAULT/bind_port':                  value => $bind_port;
    'DEFAULT/backlog':                    value => $backlog;
    'DEFAULT/workers':                    value => $workers;
    'DEFAULT/show_image_direct_url':      value => $show_image_direct_url;
    'DEFAULT/location_strategy':          value => $location_strategy;
    'DEFAULT/scrub_time':                 value => $scrub_time;
    'DEFAULT/delayed_delete':             value => $delayed_delete;
    'DEFAULT/cache_prefetcher_interval':  value => $cache_prefetcher_interval;
    'DEFAULT/image_cache_dir':            value => $image_cache_dir;
    'DEFAULT/image_cache_stall_time':     value => $image_cache_stall_time;
    'DEFAULT/image_cache_max_size':       value => $image_cache_max_size;
    'DEFAULT/enabled_import_methods':     value => $enabled_import_methods_real;
    'DEFAULT/node_staging_uri':           value => $node_staging_uri;
    'DEFAULT/worker_self_reference_url':  value => $worker_self_reference_url;
    'DEFAULT/image_member_quota':         value => $image_member_quota;
    'DEFAULT/limit_param_default':        value => $limit_param_default;
    'DEFAULT/api_limit_max':              value => $api_limit_max;
  }

  if $show_multiple_locations {
    warning('The show_multiple_locations parameter is deprecated, and will be removed in a future release')
    glance_api_config {
      'DEFAULT/show_multiple_locations': value => $show_multiple_locations;
    }
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

  if $enabled_backends {
    $enabled_backends_array = any2array($enabled_backends)

    # Verify the backend types are valid.
    $enabled_backends_array.each |$backend| {
      $backend_type = split($backend, /:/)[1]

      unless $backend_type =~ /file|http|swift|rbd|sheepdog|cinder|vsphere/ {
        fail("\'${backend_type}\' is not a valid backend type.")
      }
    }

    # Verify the backend identifiers are unique and the default_backend is valid.
    $backend_ids = $enabled_backends_array.map |$backend| { split($backend, /:/)[0] }

    unless $backend_ids == unique($backend_ids) {
      fail('All backend identifiers in enabled_backends must be unique.')
    }
    unless $default_backend {
      fail('A glance default_backend must be specified.')
    }
    unless $default_backend in $backend_ids {
      fail("The default_backend \'${default_backend}\' is not a valid backend identifier.")
    }

    glance_api_config {
      'DEFAULT/enabled_backends':     value  => join($enabled_backends_array, ',');
      'glance_store/default_backend': value  => $default_backend;
      'glance_store/stores':          ensure => absent;
      'glance_store/default_store':   ensure => absent;
    }

  } elsif $stores or $default_store {
    warning('The stores and default_store parameters are deprecated. Please use \
enabled_backends instead.')

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
  } else {
    warning('Glance-api is being provisioned without any backends')
  }

  glance_api_config {
    'glance_store/filesystem_store_metadata_file': value => $filesystem_store_metadata_file;
    'glance_store/filesystem_store_file_perm':     value => $filesystem_store_file_perm;
  }

  glance_api_config {
    'image_format/container_formats': value => join(any2array($container_formats), ',');
    'image_format/disk_formats':      value => join(any2array($disk_formats), ',');
  }

  resources { 'glance_api_config':
    purge => $purge_config,
  }

  glance_cache_config {
    'DEFAULT/image_cache_dir':        value => $image_cache_dir;
    'DEFAULT/image_cache_stall_time': value => $image_cache_stall_time;
    'DEFAULT/image_cache_max_size':   value => $image_cache_max_size;
  }

  if $image_import_plugins != $::os_service_default {
    $image_import_plugins_real = sprintf('[%s]', join(any2array($image_import_plugins), ','))
  } else {
    $image_import_plugins_real = $image_import_plugins
  }

  glance_image_import_config {
    'image_import_opts/image_import_plugins':       value => $image_import_plugins_real;
    'image_conversion/output_format':               value => $image_conversion_output_format;
    'inject_metadata_properties/inject':            value => $inject_metadata_properties;
    'inject_metadata_properties/ignore_user_roles': value => $ignore_user_roles;
  }

  # Set the pipeline, it is allowed to be blank
  if $pipeline != '' {
    validate_legacy(Pattern[/^(\w+([+]\w+)*)*$/], 'validate_re', $pipeline, ['^(\w+([+]\w+)*)*$'])

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
    include glance::api::authtoken
  }

  oslo::middleware { 'glance_api_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  # SSL Options
  glance_api_config {
    'DEFAULT/cert_file': value => $cert_file;
    'DEFAULT/key_file' : value => $key_file;
    'DEFAULT/ca_file'  : value => $ca_file;
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
    $auth_url              = $::glance::api::authtoken::www_authenticate_uri
    $defaults = {
      'glance-api' => {
        # lint:ignore:140chars
        'command'  => "glance --os-auth-url ${auth_url} --os-project-name ${keystone_project_name} --os-username ${keystone_username} --os-password ${keystone_password} image-list",
        # lint:endignore
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[glance-api]'})
  }

}
