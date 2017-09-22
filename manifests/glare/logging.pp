# == Class glance::glare::logging
#
#  glance glare extended logging configuration. Deprecated.
#
# === Deprecated parameters
#
#  [*debug*]
#  [*use_syslog*]
#  [*use_stderr*]
#  [*log_facility*]
#  [*log_dir*]
#  [*log_file*]
#  [*logging_context_format_string*]
#  [*logging_default_format_string*]
#  [*logging_debug_format_suffix*]
#  [*logging_exception_prefix*]
#  [*log_config_append*]
#  [*default_log_levels*]
#  [*publish_errors*]
#  [*fatal_deprecations*]
#  [*instance_format*]
#  [*instance_uuid_format*]
#  [*log_date_format*]
#
class glance::glare::logging(
  $use_syslog                    = undef,
  $use_stderr                    = undef,
  $log_facility                  = undef,
  $log_dir                       = undef,
  $log_file                      = undef,
  $debug                         = undef,
  $logging_context_format_string = undef,
  $logging_default_format_string = undef,
  $logging_debug_format_suffix   = undef,
  $logging_exception_prefix      = undef,
  $log_config_append             = undef,
  $default_log_levels            = undef,
  $publish_errors                = undef,
  $fatal_deprecations            = undef,
  $instance_format               = undef,
  $instance_uuid_format          = undef,
  $log_date_format               = undef,
) {

  warning("Class ::glance::glare::logging is deprecated since Glare was \
removed from Glance. Now Glare is separated project and all configuration \
was moved to puppet-glare module as well.")

}
