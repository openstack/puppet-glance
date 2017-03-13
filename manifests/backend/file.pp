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
# === Deprecated parameters:
#
# [*glare_enabled*]
#   (optional) Whether enabled Glance Glare API.
#   Defaults to undef
#
class glance::backend::file(
  $filesystem_store_datadir = '/var/lib/glance/images/',
  $multi_store              = false,
  $glare_enabled            = undef,
) {

  include ::glance::deps

  glance_api_config {
    'glance_store/filesystem_store_datadir': value => $filesystem_store_datadir;
  }

  if $glare_enabled != undef {
    warning("Since Glare was removed from Glance and now it is separate project, \
you should use puppet-glare module for configuring Glare service.")
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'file'; }
  }

  glance_cache_config {
    'glance_store/filesystem_store_datadir': value => $filesystem_store_datadir;
  }
}
