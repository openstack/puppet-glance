# == Class: glance::cache::pruner
#
# Installs a cron job to run glance-cache-pruner.
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '*/30'.
#
#  [*hour*]
#    (optional) Defaults to '*'.
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
class glance::cache::pruner(
  $minute           = '*/30',
  $hour             = '*',
  $monthday         = '*',
  $month            = '*',
  $weekday          = '*',
  $command_options  = '',
  $maxdelay         = 0,
  Enum['present', 'absent'] $ensure = 'present',
) {

  include glance::deps
  include glance::params

  if $maxdelay == 0 {
    $sleep = ''
  } else {
    $sleep = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'glance-cache-pruner':
    ensure      => $ensure,
    command     => "${sleep}${glance::params::cache_pruner_command} ${command_options}",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin',
    user        => $::glance::params::user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['glance::config::end'],
  }
}
