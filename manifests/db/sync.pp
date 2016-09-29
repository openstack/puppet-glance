#
# Class to execute glance dbsync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the glance-manage db sync command. These will be inserted
#   in the command line between 'glance-manage' and 'db sync'.
#   Defaults to '--config-file /etc/glance/glance-registry.conf'
#
class glance::db::sync(
  $extra_params = '--config-file /etc/glance/glance-registry.conf',
) {

  include ::glance::deps
  include ::glance::params

  exec { 'glance-manage db_sync':
    command     => "glance-manage ${extra_params} db_sync",
    path        => '/usr/bin',
    user        => 'glance',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['glance::install::end'],
      Anchor['glance::config::end'],
      Anchor['glance::dbsync::begin']
    ],
    notify      => Anchor['glance::dbsync::end'],
  }

}
