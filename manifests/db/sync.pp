#
# Class to execute glance dbsync
#
class glance::db::sync {

  include ::glance::params

  Package<| tag == 'glance-package' |> ~> Exec['glance-manage db_sync']
  Exec['glance-manage db_sync'] ~> Service<| tag == 'glance-service' |>

  Glance_registry_config<||> ~> Exec['glance-manage db_sync']
  Glance_api_config<||> ~> Exec['glance-manage db_sync']
  Glance_cache_config<||> ~> Exec['glance-manage db_sync']

  exec { 'glance-manage db_sync':
    command     => $::glance::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'glance',
    refreshonly => true,
    logoutput   => on_failure,
  }

}
