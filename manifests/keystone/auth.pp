# == Class: glance::keystone::auth
#
# Sets up glance users, service and endpoint
#
# == Parameters:
#
# [*password*]
#   Password for glance user. Required.
#
# [*email*]
#   Email for glance user. Optional. Defaults to 'glance@localhost'.
#
# [*auth_name*]
#   Username for glance service. Optional. Defaults to 'glance'.
#
# [*configure_endpoint*]
#   Should glance endpoint be configured? Optional. Defaults to 'true'.
#
# [*configure_user*]
#   Should the service user be configured? Optional. Defaults to 'true'.
#
# [*configure_user_role*]
#   Should the admin role be configured for the service user?
#   Optional. Defaults to 'true'.
#
# [*service_name*]
#    Name of the service. Optional.
#    Defaults to value of auth_name.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'image'.
#
# [*public_address*]
#    Public address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*admin_address*]
#    Admin address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*internal_address*]
#    Internal address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*port*]
#    Port for endpoint. Optional. Defaults to '9292'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for glance user. Optional. Defaults to 'services'.
#
# [*public_protocol*]
#    Protocol for public endpoint. Optional. Defaults to 'http'.
#
# [*internal_protocol*]
#    Protocol for internal endpoint. Optional. Defaults to 'http'.
#
# [*admin_protocol*]
#    Protocol for admin endpoint. Optional. Defaults to 'http'.
#
class glance::keystone::auth(
  $password,
  $email               = 'glance@localhost',
  $auth_name           = 'glance',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_type        = 'image',
  $public_address      = '127.0.0.1',
  $admin_address       = '127.0.0.1',
  $internal_address    = '127.0.0.1',
  $port                = '9292',
  $region              = 'RegionOne',
  $tenant              = 'services',
  $public_protocol     = 'http',
  $admin_protocol      = 'http',
  $internal_protocol   = 'http'
) {

  if $service_name == undef {
    $real_service_name = $auth_name
  } else {
    $real_service_name = $service_name
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${real_service_name}"]  ~> Service <| name == 'glance-api' |>
  }

  keystone::resource::service_identity { $auth_name:
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => 'OpenStack Image Service',
    service_name        => $real_service_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${port}",
    admin_url           => "${admin_protocol}://${admin_address}:${port}",
    internal_url        => "${internal_protocol}://${internal_address}:${port}",
  }

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'glance-registry' |>
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'glance-api' |>
  }

}
