# class: glance::glare::authtoken
#
# Configure the keystone_authtoken section in the Glance Glare configuration file. Deprecated.
#
# === Deprecated parameters
#
# [*username*]
# [*password*]
# [*auth_url*]
# [*project_name*]
# [*user_domain_name*]
# [*project_domain_name*]
# [*insecure*]
# [*auth_section*]
# [*auth_type*]
# [*auth_uri*]
# [*auth_version*]
# [*cache*]
# [*cafile*]
# [*certfile*]
# [*check_revocations_for_cached*]
# [*delay_auth_decision*]
# [*enforce_token_bind*]
# [*hash_algorithms*]
# [*http_connect_timeout*]
# [*http_request_max_retries*]
# [*include_service_catalog*]
# [*keyfile*]
# [*memcache_pool_conn_get_timeout*]
# [*memcache_pool_dead_retry*]
# [*memcache_pool_maxsize*]
# [*memcache_pool_socket_timeout*]
# [*memcache_pool_unused_timeout*]
# [*memcache_secret_key*]
# [*memcache_security_strategy*]
# [*memcache_use_advanced_pool*]
# [*memcached_servers*]
# [*manage_memcache_package*]
# [*region_name*]
# [*revocation_cache_time*]
# [*token_cache_time*]
# [*signing_dir*]
#
class glance::glare::authtoken(
  $username                       = undef,
  $password                       = undef,
  $auth_url                       = undef,
  $project_name                   = undef,
  $user_domain_name               = undef,
  $project_domain_name            = undef,
  $insecure                       = undef,
  $auth_section                   = undef,
  $auth_type                      = undef,
  $auth_uri                       = undef,
  $auth_version                   = undef,
  $cache                          = undef,
  $cafile                         = undef,
  $certfile                       = undef,
  $check_revocations_for_cached   = undef,
  $delay_auth_decision            = undef,
  $enforce_token_bind             = undef,
  $hash_algorithms                = undef,
  $http_connect_timeout           = undef,
  $http_request_max_retries       = undef,
  $include_service_catalog        = undef,
  $keyfile                        = undef,
  $memcache_pool_conn_get_timeout = undef,
  $memcache_pool_dead_retry       = undef,
  $memcache_pool_maxsize          = undef,
  $memcache_pool_socket_timeout   = undef,
  $memcache_pool_unused_timeout   = undef,
  $memcache_secret_key            = undef,
  $memcache_security_strategy     = undef,
  $memcache_use_advanced_pool     = undef,
  $memcached_servers              = undef,
  $manage_memcache_package        = undef,
  $region_name                    = undef,
  $revocation_cache_time          = undef,
  $token_cache_time               = undef,
  $signing_dir                    = undef,
) {

  warning("Class ::glance::glare::authtoken is deprecated since Glare was removed \
from Glance. Now Glare is separated project and all configuration was moved to \
puppet-glare module as well.")

}
