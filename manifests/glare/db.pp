# == Class: glance::glare::db
#
#  Configure the Glance Glare database. Deprecated.
#
# === Deprecated parameters
#
# [*database_connection*]
# [*database_idle_timeout*]
# [*database_min_pool_size*]
# [*database_max_pool_size*]
# [*database_max_retries*]
# [*database_retry_interval*]
# [*database_max_overflow*]
#
class glance::glare::db (
  $database_connection     = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
) {

  warning("Class ::glance::glare::db is deprecated since Glare was removed from Glance. \
Now Glare is separated project and all configuration was moved to \
puppet-glare module as well.")

}
