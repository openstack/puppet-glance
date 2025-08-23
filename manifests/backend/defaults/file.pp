# == Class: glance::backend::defaults::file
#
# Configure common defaults for all file backends
#
# === Parameters:
#
# [*filesystem_store_datadir*]
#   (optional) Directory where dist images are stored.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_metadata_file*]
#   (optional) Filesystem store metadata file.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_file_perm*]
#   (optional) File access permissions for the image files.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_chunk_size*]
#   (optional) Chunk size, in bytes.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_thin_provisioning*]
#   (optional) Boolean describing if thin provisioning is enabled or not
#   Defaults to $facts['os_service_default']
#
class glance::backend::defaults::file (
  $filesystem_store_datadir       = $facts['os_service_default'],
  $filesystem_store_metadata_file = $facts['os_service_default'],
  $filesystem_store_file_perm     = $facts['os_service_default'],
  $filesystem_store_chunk_size    = $facts['os_service_default'],
  $filesystem_thin_provisioning   = $facts['os_service_default'],
) {
  include glance::deps

  glance_api_config {
    'backend_defaults/filesystem_store_datadir':       value => $filesystem_store_datadir;
    'backend_defaults/filesystem_store_metadata_file': value => $filesystem_store_metadata_file;
    'backend_defaults/filesystem_store_file_perm':     value => $filesystem_store_file_perm;
    'backend_defaults/filesystem_store_chunk_size':    value => $filesystem_store_chunk_size;
    'backend_defaults/filesystem_thin_provisioning':   value => $filesystem_thin_provisioning;
  }

  glance_cache_config {
    'backend_defaults/filesystem_store_datadir':       value => $filesystem_store_datadir;
    'backend_defaults/filesystem_store_metadata_file': value => $filesystem_store_metadata_file;
    'backend_defaults/filesystem_store_file_perm':     value => $filesystem_store_file_perm;
    'backend_defaults/filesystem_store_chunk_size':    value => $filesystem_store_chunk_size;
    'backend_defaults/filesystem_thin_provisioning':   value => $filesystem_thin_provisioning;
  }
}
