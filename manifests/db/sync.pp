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

  include ::glance::params

  Package<| tag == 'glance-package' |> ~> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync'] ~> Service<| tag == 'glance-service' |>

  Glance_registry_config<||> ~> Exec['glance-manage db_sync']
  Glance_api_config<||> ~> Exec['glance-manage db_sync']
  Glance_cache_config<||> ~> Exec['glance-manage db_sync']

  exec { 'glance-manage db_sync':
    command     => "glance-manage ${extra_params} db_sync",
    path        => '/usr/bin',
    user        => 'glance',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
  }

}
