# class: glance::api::authtoken
#
# Configure the keystone_authtoken section in the Glance API configuration file
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'glance'
#
# [*password*]
#   (Optional) Password to create for the service user
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://127.0.0.1:5000'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_name
#   Defaults to 'Default'
#
# [*insecure*]
#   (Optional) If true, explicitly allow TLS without checking server cert
#   against any certificate authorities.  WARNING: not recommended.  Use with
#   caution.
#   Defaults to $::os_service_default
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin specific options
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to 'password'
#
# [*www_authenticate_uri*]
#   (Optional) Complete public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000'.
#
# [*auth_version*]
#   (Optional) API version of the admin Identity API endpoint.
#   Defaults to $::os_service_default.
#
# [*cache*]
#   (Optional) Env key for the swift cache.
#   Defaults to $::os_service_default.
#
# [*cafile*]
#   (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to $::os_service_default.
#
# [*certfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $::os_service_default.
#
# [*delay_auth_decision*]
#   (Optional) Do not handle authorization requests within the middleware, but
#   delegate the authorization decision to downstream WSGI components. Boolean
#   value
#   Defaults to $::os_service_default.
#
# [*enforce_token_bind*]
#   (Optional) Used to control the use and type of token binding. Can be set
#   to: "disabled" to not check token binding. "permissive" (default) to
#   validate binding information if the bind type is of a form known to the
#   server and ignore it if not. "strict" like "permissive" but if the bind
#   type is unknown the token will be rejected. "required" any form of token
#   binding is needed to be allowed. Finally the name of a binding method that
#   must be present in tokens. String value.
#   Defaults to $::os_service_default.
#
# [*http_connect_timeout*]
#   (Optional) Request timeout value for communicating with Identity API
#   server.
#   Defaults to $::os_service_default.
#
# [*http_request_max_retries*]
#   (Optional) How many times are we trying to reconnect when communicating
#   with Identity API Server. Integer value
#   Defaults to $::os_service_default.
#
# [*include_service_catalog*]
#   (Optional) Indicate whether to set the X-Service-Catalog header. If False,
#   middleware will not ask for service catalog on token validation and will
#   not set the X-Service-Catalog header. Boolean value.
#   Defaults to $::os_service_default.
#
# [*keyfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $::os_service_default.
#
# [*memcache_pool_conn_get_timeout*]
#   (Optional) Number of seconds that an operation will wait to get a memcached
#   client connection from the pool. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_dead_retry*]
#   (Optional) Number of seconds memcached server is considered dead before it
#   is tried again. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_maxsize*]
#   (Optional) Maximum total number of open connections to every memcached
#   server. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_socket_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_unused_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_secret_key*]
#   (Optional, mandatory if memcache_security_strategy is defined) This string
#   is used for key derivation.
#   Defaults to $::os_service_default.
#
# [*memcache_security_strategy*]
#   (Optional) If defined, indicate whether token data should be authenticated
#   or authenticated and encrypted. If MAC, token data is authenticated (with
#   HMAC) in the cache. If ENCRYPT, token data is encrypted and authenticated
#   in the cache. If the value is not one of these options or empty,
#   auth_token will raise an exception on initialization.
#   Defaults to $::os_service_default.
#
# [*memcache_use_advanced_pool*]
#   (Optional)  Use the advanced (eventlet safe) memcached client pool. The
#   advanced pool will only work under python 2.x Boolean value
#   Defaults to $::os_service_default.
#
# [*memcached_servers*]
#   (Optional) Optionally specify a list of memcached server(s) to use for
#   caching. If left undefined, tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
# [*manage_memcache_package*]
#  (Optional) Whether to install the python-memcache package.
#  Defaults to false.
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $::os_service_default.
#
# [*token_cache_time*]
#   (Optional) In order to prevent excessive effort spent validating tokens,
#   the middleware caches previously-seen tokens for a configurable duration
#   (in seconds). Set to -1 to disable caching completely. Integer value
#   Defaults to $::os_service_default.
#
# [*service_token_roles*]
#   (Optional) A choice of roles that must be present in a service token.
#   Service tokens are allowed to request that an expired token
#   can be used and so this check should tightly control that
#   only actual services should be sending this token. Roles
#   here are applied as an ANY check so any role in this list
#   must be present. For backwards compatibility reasons this
#   currently only affects the allow_expired check. (list value)
#   Defaults to $::os_service_default.
#
# [*service_token_roles_required*]
#   (optional) backwards compatibility to ensure that the service tokens are
#   compared against a list of possible roles for validity
#   true/false
#   Defaults to $::os_service_default.
#
# [*interface*]
#  (Optional) Interface to use for the Identity API endpoint. Valid values are
#  "public", "internal" or "admin".
#  Defaults to $::os_service_default.
#
class glance::api::authtoken(
  $username                       = 'glance',
  $password                       = $::os_service_default,
  $auth_url                       = 'http://127.0.0.1:5000',
  $project_name                   = 'services',
  $user_domain_name               = 'Default',
  $project_domain_name            = 'Default',
  $insecure                       = $::os_service_default,
  $auth_section                   = $::os_service_default,
  $auth_type                      = 'password',
  $www_authenticate_uri           = 'http://127.0.0.1:5000',
  $auth_version                   = $::os_service_default,
  $cache                          = $::os_service_default,
  $cafile                         = $::os_service_default,
  $certfile                       = $::os_service_default,
  $delay_auth_decision            = $::os_service_default,
  $enforce_token_bind             = $::os_service_default,
  $http_connect_timeout           = $::os_service_default,
  $http_request_max_retries       = $::os_service_default,
  $include_service_catalog        = $::os_service_default,
  $keyfile                        = $::os_service_default,
  $memcache_pool_conn_get_timeout = $::os_service_default,
  $memcache_pool_dead_retry       = $::os_service_default,
  $memcache_pool_maxsize          = $::os_service_default,
  $memcache_pool_socket_timeout   = $::os_service_default,
  $memcache_pool_unused_timeout   = $::os_service_default,
  $memcache_secret_key            = $::os_service_default,
  $memcache_security_strategy     = $::os_service_default,
  $memcache_use_advanced_pool     = $::os_service_default,
  $memcached_servers              = $::os_service_default,
  $manage_memcache_package        = false,
  $region_name                    = $::os_service_default,
  $token_cache_time               = $::os_service_default,
  $service_token_roles            = $::os_service_default,
  $service_token_roles_required   = $::os_service_default,
  $interface                      = $::os_service_default,
) {

  include ::glance::deps

  if is_service_default($password) {
    fail('Please set password for Glance service user')
  }

  keystone::resource::authtoken { 'glance_api_config':
      username                       => $username,
      password                       => $password,
      project_name                   => $project_name,
      auth_url                       => $auth_url,
      www_authenticate_uri           => $www_authenticate_uri,
      auth_version                   => $auth_version,
      auth_type                      => $auth_type,
      auth_section                   => $auth_section,
      user_domain_name               => $user_domain_name,
      project_domain_name            => $project_domain_name,
      insecure                       => $insecure,
      cache                          => $cache,
      cafile                         => $cafile,
      certfile                       => $certfile,
      delay_auth_decision            => $delay_auth_decision,
      enforce_token_bind             => $enforce_token_bind,
      http_connect_timeout           => $http_connect_timeout,
      http_request_max_retries       => $http_request_max_retries,
      include_service_catalog        => $include_service_catalog,
      keyfile                        => $keyfile,
      memcache_pool_conn_get_timeout => $memcache_pool_conn_get_timeout,
      memcache_pool_dead_retry       => $memcache_pool_dead_retry,
      memcache_pool_maxsize          => $memcache_pool_maxsize,
      memcache_pool_socket_timeout   => $memcache_pool_socket_timeout,
      memcache_secret_key            => $memcache_secret_key,
      memcache_security_strategy     => $memcache_security_strategy,
      memcache_use_advanced_pool     => $memcache_use_advanced_pool,
      memcache_pool_unused_timeout   => $memcache_pool_unused_timeout,
      memcached_servers              => $memcached_servers,
      manage_memcache_package        => $manage_memcache_package,
      region_name                    => $region_name,
      token_cache_time               => $token_cache_time,
      service_token_roles            => $service_token_roles,
      service_token_roles_required   => $service_token_roles_required,
      interface                      => $interface,
    }
}
