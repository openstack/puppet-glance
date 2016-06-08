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
#    Defaults to 'glance'.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'image'.
#
# [*service_description*]
#    Description for keystone service. Optional. Defaults to 'OpenStack Image Service'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for glance user. Optional. Defaults to 'services'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9292')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9292')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9292')
#   This url should *not* contain any trailing '/'.
#
# === Examples
#
#  class { 'glance::keystone::auth':
#    password     => '123456',
#    public_url   => 'https://10.0.0.10:9292',
#    internal_url => 'https://10.0.0.11:9292',
#    admin_url    => 'https://10.0.0.11:9292',
#  }
#
class glance::keystone::auth(
  $password,
  $email               = 'glance@localhost',
  $auth_name           = 'glance',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'glance',
  $service_type        = 'image',
  $region              = 'RegionOne',
  $tenant              = 'services',
  $service_description = 'OpenStack Image Service',
  $public_url          = 'http://127.0.0.1:9292',
  $admin_url           = 'http://127.0.0.1:9292',
  $internal_url        = 'http://127.0.0.1:9292',
) {

  include ::glance::deps

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::${service_type}"] ~> Anchor['glance::service::begin']
  }

  keystone::resource::service_identity { 'glance':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    auth_name           => $auth_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['glance::service::begin']
  }

}
