# === class: glance::backend::file
#
# used to configure file backends for glance
#
# === parameters:
#
#  [*filesystem_store_datadir*]
#    Location where dist images are stored when
#    default_store == file.
#    Optional. Default: /var/lib/glance/images/
#
#  [*filesystem_thin_provisioning*]
#    (optional) Boolean describing if thin provisioning is enabled or not
#    Defaults to $facts['os_service_default']
#
#  [*multi_store*]
#    (optional) Boolean describing if multiple backends will be configured
#    Defaults to false
#
class glance::backend::file (
  $filesystem_store_datadir     = '/var/lib/glance/images/',
  $filesystem_thin_provisioning = $facts['os_service_default'],
  Boolean $multi_store          = false,
) {
  include glance::deps

  warning('glance::backend::file is deprecated. Use glance::backend::multistore::file instead.')

  glance::backend::multistore::file { 'glance_store':
    filesystem_store_datadir     => $filesystem_store_datadir,
    filesystem_thin_provisioning => $filesystem_thin_provisioning,
    store_description            => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'file'; }
    glance_cache_config { 'glance_store/default_store': value => 'file'; }
  }
}
