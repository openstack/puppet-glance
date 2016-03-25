# == class: glance::backend::s3
#
# configures the storage backend for glance
# as a s3 instance
#
# === parameters:
#
#  [*access_key*]
#    (Required) The S3 query token access key.
#
#  [*secret_key*]
#    (Required) The S3 query token secret key.
#
#  [*host*]
#    (Required) The host where the S3 server is listening.
#
#  [*bucket*]
#    (Required) The S3 bucket to be used to store the Glance data.
#
#  [*bucket_url_format*]
#    (Optional) The S3 calling format used to determine the bucket. Either
#    'subdomain' or 'path' can be used.
#    Default: 'subdomain'
#
#  [*create_bucket_on_put*]
#    (Optional) A boolean to determine if the S3 bucket should be created on
#    upload if it does not exist or if an error should be returned to the user.
#    Default: False
#
#  [*large_object_size*]
#    (Optional) What size, in MB, should S3 start chunking image files and do a
#    multipart upload in S3.
#    Default: 100
#
#  [*large_object_chunk_size*]
#    (Optional) What multipart upload part size, in MB, should S3 use when
#    uploading parts. The size must be greater than or equal to 5M.
#    Default: 10
#
#  [*object_buffer_dir*]
#    (Optional) The local directory where uploads will be staged before they are
#    transferred into S3.
#    Default: undef
#
#  [*thread_pools*]
#    (Optional) The number of thread pools to perform a multipart upload in S3.
#    Default: 10
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
# [*glare_enabled*]
#   (optional) Whether enabled Glance Glare API.
#   Defaults to false
#
#  === deprecated parameters:
#
#  [*default_store*]
#   (Optional) DEPRECATED Whether to set S3 as the default backend store.
#   Default: undef
#
class glance::backend::s3(
  $access_key,
  $secret_key,
  $host,
  $bucket,
  $bucket_url_format        = 'subdomain',
  $create_bucket_on_put     = false,
  $large_object_size        = 100,
  $large_object_chunk_size  = 10,
  $object_buffer_dir        = undef,
  $thread_pools             = 10,
  $multi_store              = false,
  $glare_enabled            = false,
  # deprecated parameters
  $default_store            = undef,
) {

  if !is_integer($large_object_chunk_size) or $large_object_chunk_size < 5 {
    fail('glance::backend::s3::large_object_chunk_size must be an integer >= 5')
  }

  if !($bucket_url_format in ['subdomain', 'path']) {
    fail('glance::backend::s3::bucket_url_format must be either "subdomain" or "path"')
  }

  if $default_store {
    warning('The default_store parameter is deprecated in glance::backend::s3, you should declare it in glance::api')
  }

  glance_api_config {
    'glance_store/s3_store_access_key':              value => $access_key;
    'glance_store/s3_store_secret_key':              value => $secret_key;
    'glance_store/s3_store_host':                    value => $host;
    'glance_store/s3_store_bucket':                  value => $bucket;
    'glance_store/s3_store_bucket_url_format':       value => $bucket_url_format;
    'glance_store/s3_store_create_bucket_on_put':    value => $create_bucket_on_put;
    'glance_store/s3_store_large_object_size':       value => $large_object_size;
    'glance_store/s3_store_large_object_chunk_size': value => $large_object_chunk_size;
    'glance_store/s3_store_thread_pools':            value => $thread_pools;
  }

  if $glare_enabled {
    glance_glare_config {
      'glance_store/s3_store_access_key':              value => $access_key;
      'glance_store/s3_store_secret_key':              value => $secret_key;
      'glance_store/s3_store_host':                    value => $host;
      'glance_store/s3_store_bucket':                  value => $bucket;
      'glance_store/s3_store_bucket_url_format':       value => $bucket_url_format;
      'glance_store/s3_store_create_bucket_on_put':    value => $create_bucket_on_put;
      'glance_store/s3_store_large_object_size':       value => $large_object_size;
      'glance_store/s3_store_large_object_chunk_size': value => $large_object_chunk_size;
      'glance_store/s3_store_thread_pools':            value => $thread_pools;
    }
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 's3'; }
    if $glare_enabled {
      glance_glare_config { 'glance_store/default_store': value => 's3'; }
    }
  }

  if $object_buffer_dir {
    glance_api_config { 'glance_store/s3_store_object_buffer_dir': value => $object_buffer_dir; }
    if $glare_enabled {
      glance_glare_config { 'glance_store/s3_store_object_buffer_dir': value => $object_buffer_dir; }
    }
  } else {
    glance_api_config { 'glance_store/s3_store_object_buffer_dir': ensure => absent; }
    if $glare_enabled {
      glance_glare_config { 'glance_store/s3_store_object_buffer_dir': ensure => absent; }
    }
  }

}
