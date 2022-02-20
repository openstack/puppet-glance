#
# Class to execute glance dbsync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the glance-manage db sync command. These will be inserted
#   in the command line between 'glance-manage' and 'db sync'.
#   Defaults to ''
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class glance::db::sync(
  $extra_params    = '',
  $db_sync_timeout = 300,
) {

  include glance::deps
  include glance::params

  exec { 'glance-manage db_sync':
    command     => "glance-manage ${extra_params} db_sync",
    path        => '/usr/bin',
    user        => $::glance::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['glance::install::end'],
      Anchor['glance::config::end'],
      Anchor['glance::dbsync::begin']
    ],
    notify      => Anchor['glance::dbsync::end'],
    tag         => 'openstack-db',
  }

}
