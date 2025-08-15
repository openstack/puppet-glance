# == Class: glance::cache::cleaner
#
# Installs a cron job to run glance-cache-cleaner.
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*command_options*]
#    (optional) command options to add to the cronjob
#    (eg. point to config file, or redirect output)
#    Defaults to ''.
#
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
#  [*ensure*]
#    (optional) Ensure cron jobs present or absent
#    Defaults to present.
#
class glance::cache::cleaner(
  $minute                           = 1,
  $hour                             = 0,
  $monthday                         = '*',
  $month                            = '*',
  $weekday                          = '*',
  $command_options                  = '',
  Integer[0] $maxdelay              = 0,
  Enum['present', 'absent'] $ensure = 'present',
) {

  include glance::deps
  include glance::params

  if $maxdelay == 0 {
    $sleep = ''
  } else {
    $sleep = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'glance-cache-cleaner':
    ensure      => $ensure,
    command     => "${sleep}${glance::params::cache_cleaner_command} ${command_options}",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin',
    user        => $glance::params::user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['glance::config::end'],
  }
}
