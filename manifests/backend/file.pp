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
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glance::backend::file(
  $filesystem_store_datadir = '/var/lib/glance/images/',
  $multi_store              = false,
) {

  include glance::deps

  warning('glance::backend::file is deprecated. Use glance::backend::multistore::file instead.')

  glance::backend::multistore::file { 'glance_store':
    filesystem_store_datadir => $filesystem_store_datadir,
    store_description        => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'file'; }
  }
}
