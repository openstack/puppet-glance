# == Class: glance::keystone::glare_auth
#
# Sets up glare users, service and endpoint for Glance Glare
#
# == Parameters:
#
# [*password*]
#   Password for glare user. Required.
#
# [*email*]
#   Email for glance user. Optional. Defaults to 'glare@localhost'.
#
# [*auth_name*]
#   Username for glare service. Optional. Defaults to 'glare'.
#
# [*configure_endpoint*]
#   Should glare endpoint be configured? Optional. Defaults to 'true'.
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
#    Defaults to 'Glance Artifacts'.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'artifact'.
#
# [*service_description*]
#    Description for keystone service. Optional. Defaults to 'Glance Artifact Service'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for glare user. Optional. Defaults to 'services'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9494')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9494')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9494')
#   This url should *not* contain any trailing '/'.
#
# === Examples
#
#  class { 'glance::keystone::glare_auth':
#    public_url   => 'https://10.0.0.10:9494',
#    internal_url => 'https://10.0.0.11:9494',
#    admin_url    => 'https://10.0.0.11:9494',
#  }
#
class glance::keystone::glare_auth(
  $password,
  $email               = 'glare@localhost',
  $auth_name           = 'glare',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'Glance Artifacts',
  $service_type        = 'artifact',
  $region              = 'RegionOne',
  $tenant              = 'services',
  $service_description = 'Glance Artifact Service',
  $public_url          = 'http://127.0.0.1:9494',
  $admin_url           = 'http://127.0.0.1:9494',
  $internal_url        = 'http://127.0.0.1:9494',
) {

  $real_service_name = pick($service_name, $auth_name)

  if $configure_endpoint {
    Keystone_endpoint["${region}/${real_service_name}::${service_type}"]  ~> Service<| title == 'glance-glare' |>
  }

  keystone::resource::service_identity { $auth_name:
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $real_service_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service<| title == 'glance-glare' |>
  }
}
