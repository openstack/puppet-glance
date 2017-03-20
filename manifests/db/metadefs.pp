#
# Class to load default Glance metadata definitions
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append to the
#   glance-manage db_load_metadefs command. These will be inserted in the
#   command line between 'glance-manage' and 'db_load_metadefs'.
#   Defaults to ''
#
class glance::db::metadefs(
  $extra_params = '',
) {

  include ::glance::deps
  include ::glance::params

  exec { 'glance-manage db_load_metadefs':
    command     => "glance-manage ${extra_params} db_load_metadefs",
    path        => '/usr/bin',
    user        => 'glance',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['glance::install::end'],
      Anchor['glance::config::end'],
      Anchor['glance::dbsync::end']
    ],
  }

}
