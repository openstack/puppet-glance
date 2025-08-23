# == Class: glance::backend::defaults::s3
#
# Configure common defaults for all rbd backends
#
# === Parameters:
#
# [*s3_store_host*]
#   (required) The host where the S3 server is listening.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_access_key*]
#   (required) The S3 query token access key.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_secret_key*]
#   (required) The S3 query token secret key.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_bucket*]
#   (required) The S3 bucket to be used to store the Glance data.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_create_bucket_on_put*]
#   (optional) Determine whether S3 should create a new bucket.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_bucket_url_format*]
#   (optional) The S3 calling format used to determine the object.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_large_object_size*]
#   (optional) What size, in MB, should S3 start chunking image files and do
#   a multipart upload in S3.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_large_object_chunk_size*]
#   (optional) What multipart upload part size, in MB, should S3 use when
#   uploading parts.
#   Defaults to $facts['os_service_default'].
#
# [*s3_store_thread_pools*]
#   (optional) The number of thread pools to perform a multipart upload in S3.
#   Defaults to $facts['os_service_default'].
#
class glance::backend::defaults::s3 (
  $s3_store_host                    = $facts['os_service_default'],
  $s3_store_access_key              = $facts['os_service_default'],
  $s3_store_secret_key              = $facts['os_service_default'],
  $s3_store_bucket                  = $facts['os_service_default'],
  $s3_store_create_bucket_on_put    = $facts['os_service_default'],
  $s3_store_bucket_url_format       = $facts['os_service_default'],
  $s3_store_large_object_size       = $facts['os_service_default'],
  $s3_store_large_object_chunk_size = $facts['os_service_default'],
  $s3_store_thread_pools            = $facts['os_service_default'],
) {
  include glance::deps

  glance_api_config {
    'backend_defaults/s3_store_host':                    value => $s3_store_host;
    'backend_defaults/s3_store_access_key':              value => $s3_store_access_key, secret => true;
    'backend_defaults/s3_store_secret_key':              value => $s3_store_secret_key, secret => true;
    'backend_defaults/s3_store_bucket':                  value => $s3_store_bucket;
    'backend_defaults/s3_store_create_bucket_on_put':    value => $s3_store_create_bucket_on_put;
    'backend_defaults/s3_store_bucket_url_format':       value => $s3_store_bucket_url_format;
    'backend_defaults/s3_store_large_object_size':       value => $s3_store_large_object_size;
    'backend_defaults/s3_store_large_object_chunk_size': value => $s3_store_large_object_chunk_size;
    'backend_defaults/s3_store_thread_pools':            value => $s3_store_thread_pools;
  }

  glance_cache_config {
    'backend_defaults/s3_store_host':                    value => $s3_store_host;
    'backend_defaults/s3_store_access_key':              value => $s3_store_access_key, secret => true;
    'backend_defaults/s3_store_secret_key':              value => $s3_store_secret_key, secret => true;
    'backend_defaults/s3_store_bucket':                  value => $s3_store_bucket;
    'backend_defaults/s3_store_create_bucket_on_put':    value => $s3_store_create_bucket_on_put;
    'backend_defaults/s3_store_bucket_url_format':       value => $s3_store_bucket_url_format;
    'backend_defaults/s3_store_large_object_size':       value => $s3_store_large_object_size;
    'backend_defaults/s3_store_large_object_chunk_size': value => $s3_store_large_object_chunk_size;
    'backend_defaults/s3_store_thread_pools':            value => $s3_store_thread_pools;
  }
}
