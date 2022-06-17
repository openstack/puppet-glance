# == Class: glance::keystone::auth
#
# Sets up glance users, service and endpoint
#
# == Parameters:
#
# [*password*]
#   (Required) Password for glance user.
#
# [*email*]
#   (Optional) Email for glance user.
#   Defaults to 'glance@localhost'.
#
# [*auth_name*]
#   (Optional) Username for glance service.
#   Defaults to 'glance'.
#
# [*configure_endpoint*]
#   (Optional) Should glance endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'glance'
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'image'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'OpenStack Image Service'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for glance user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to glance user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to glance user.
#   Defaults to []
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9292'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9292'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9292'
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
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $service_description = 'OpenStack Image Service',
  $public_url          = 'http://127.0.0.1:9292',
  $admin_url           = 'http://127.0.0.1:9292',
  $internal_url        = 'http://127.0.0.1:9292',
) {

  include glance::deps

  Keystone::Resource::Service_identity['glance'] -> Anchor['glance::service::end']

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
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

}
