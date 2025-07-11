# == Class: glance::backend::defaults::swift
#
# Configure common defaults for all rbd backends
#
# === Parameters:
#
# [*swift_store_container*]
#   (Optional) Name of single container to store images/name prefix for
#   multiple containers.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_large_object_size*]
#   (Optional) The size threshold, in MB, after which Glance will start
#   segmenting image data.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_large_object_chunk_size*]
#   (Optional) The maximum size, in MB, of the segments when image data is
#   segmented.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_create_container_on_put*]
#   (Optional) Create container, if it doesn't already exist, when uploading
#   image.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_endpoint_type*]
#   (Optional) Endpoint type of Swift service.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_service_type*]
#   (Optional) Type of the swift service to use.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_region*]
#   (Optional) The region of Swift endpoint to use by Glance.
#   Defaults to $facts['os_service_default'].
#
# [*swift_buffer_on_upload*]
#   (Optional) Buffer image segments before upload to Swift.
#   Defaults to $facts['os_service_default'].
#
# [*swift_upload_buffer_dir*]
#   (Optional) Directory to buffer image segments before upload to Swift.
#   Defaults to $facts['os_service_default'].
#
# [*swift_store_retry_get_count*]
#   (Optional) The number of times a Swift download will be retried before
#   the request fails.
#   Defaults to $facts['os_service_default'].
#
class glance::backend::defaults::swift(
  $swift_store_container               = $facts['os_service_default'],
  $swift_store_large_object_size       = $facts['os_service_default'],
  $swift_store_large_object_chunk_size = $facts['os_service_default'],
  $swift_store_create_container_on_put = $facts['os_service_default'],
  $swift_store_endpoint_type           = $facts['os_service_default'],
  $swift_store_service_type            = $facts['os_service_default'],
  $swift_store_region                  = $facts['os_service_default'],
  $swift_buffer_on_upload              = $facts['os_service_default'],
  $swift_upload_buffer_dir             = $facts['os_service_default'],
  $swift_store_retry_get_count         = $facts['os_service_default'],
) {

  include glance::deps
  include swift::client

  glance_api_config {
    'backend_defaults/swift_store_region':                  value => $swift_store_region;
    'backend_defaults/swift_store_container':               value => $swift_store_container;
    'backend_defaults/swift_store_create_container_on_put': value => $swift_store_create_container_on_put;
    'backend_defaults/swift_store_large_object_size':       value => $swift_store_large_object_size;
    'backend_defaults/swift_store_large_object_chunk_size': value => $swift_store_large_object_chunk_size;
    'backend_defaults/swift_store_endpoint_type':           value => $swift_store_endpoint_type;
    'backend_defaults/swift_store_service_type':            value => $swift_store_service_type;
    'backend_defaults/swift_buffer_on_upload':              value => $swift_buffer_on_upload;
    'backend_defaults/swift_upload_buffer_dir':             value => $swift_upload_buffer_dir;
    'backend_defaults/swift_store_retry_get_count':         value => $swift_store_retry_get_count;
  }
  glance_cache_config {
    'backend_defaults/swift_store_region':                  value => $swift_store_region;
    'backend_defaults/swift_store_container':               value => $swift_store_container;
    'backend_defaults/swift_store_create_container_on_put': value => $swift_store_create_container_on_put;
    'backend_defaults/swift_store_large_object_size':       value => $swift_store_large_object_size;
    'backend_defaults/swift_store_large_object_chunk_size': value => $swift_store_large_object_chunk_size;
    'backend_defaults/swift_store_endpoint_type':           value => $swift_store_endpoint_type;
    'backend_defaults/swift_store_service_type':            value => $swift_store_service_type;
    'backend_defaults/swift_buffer_on_upload':              value => $swift_buffer_on_upload;
    'backend_defaults/swift_upload_buffer_dir':             value => $swift_upload_buffer_dir;
    'backend_defaults/swift_store_retry_get_count':         value => $swift_store_retry_get_count;
  }
}
