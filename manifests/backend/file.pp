#
# used to configure file backends for glance
#
#  $filesystem_store_datadir - Location where dist images are stored when
#  default_store == file.
#  Optional. Default: /var/lib/glance/images/
class glance::backend::file(
  $filesystem_store_datadir = '/var/lib/glance/images/',
  $scrubber_datadir = '/var/lib/glance/scrubber/',
  $image_cache_dir = '/var/lib/glance/image-cache/',
) inherits glance::api {

  glance_api_config {
    'DEFAULT/default_store':            value => 'file';
    'DEFAULT/filesystem_store_datadir': value => $filesystem_store_datadir;
    'DEFAULT/scrubber_datadir':         value => $scrubber_datadir;
    'DEFAULT/image_cache_dir':          value => $image_cache_dir;
  }

  glance_cache_config {
    'DEFAULT/filesystem_store_datadir': value => $filesystem_store_datadir;
  }
}
