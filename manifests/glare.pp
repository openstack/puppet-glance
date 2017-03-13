# == Class glance::glare
#
# Configure Glare Glare service in glance. Deprecated.
#
# == Deprecated parameters
#
# [*package_ensure*]
# [*bind_host*]
# [*bind_port*]
# [*backlog*]
# [*workers*]
# [*auth_strategy*]
# [*pipeline*]
# [*manage_service*]
# [*enabled*]
# [*cert_file*]
# [*key_file*]
# [*ca_file*]
# [*stores*]
# [*default_store*]
# [*multi_store*]
# [*os_region_name*]
#
class glance::glare(
  $package_ensure = undef,
  $bind_host      = undef,
  $bind_port      = undef,
  $backlog        = undef,
  $workers        = undef,
  $auth_strategy  = undef,
  $pipeline       = undef,
  $manage_service = undef,
  $enabled        = undef,
  $cert_file      = undef,
  $key_file       = undef,
  $ca_file        = undef,
  $stores         = undef,
  $default_store  = undef,
  $multi_store    = undef,
  $os_region_name = undef,
) {

  warning("Class ::glance::glare is deprecated since Glare was removed from Glance. \
Now Glare is separated project and all configuration was moved to \
puppet-glare module as well.")

}
