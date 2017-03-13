# == Class: glance::keystone::glare_auth
#
# Sets up glare users, service and endpoint for Glance Glare. Deprecated.
#
# == Deprecated parameters
#
# [*password*]
# [*email*]
# [*auth_name*]
# [*configure_endpoint*]
# [*configure_user*]
# [*configure_user_role*]
# [*service_name*]
# [*service_type*]
# [*service_description*]
# [*region*]
# [*tenant*]
# [*public_url*]
# [*admin_url*]
# [*internal_url*]
#
class glance::keystone::glare_auth(
  $password            = undef,
  $email               = undef,
  $auth_name           = undef,
  $configure_endpoint  = undef,
  $configure_user      = undef,
  $configure_user_role = undef,
  $service_name        = undef,
  $service_type        = undef,
  $region              = undef,
  $tenant              = undef,
  $service_description = undef,
  $public_url          = undef,
  $admin_url           = undef,
  $internal_url        = undef,
) {

  warning("Class ::glance::keystone::glare_auth is deprecated since Glare was \
removed from Glance. Now Glare is separated project and all configuration was \
moved to puppet-glare module as well.")

}
