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
#    Default: $::os_service_default.
#
#  [*create_bucket_on_put*]
#    (Optional) A boolean to determine if the S3 bucket should be created on
#    upload if it does not exist or if an error should be returned to the user.
#    Default: $::os_service_default.
#
#  [*large_object_size*]
#    (Optional) What size, in MB, should S3 start chunking image files and do a
#    multipart upload in S3.
#    Default: $::os_service_default.
#
#  [*large_object_chunk_size*]
#    (Optional) What multipart upload part size, in MB, should S3 use when
#    uploading parts. The size must be greater than or equal to 5M.
#    Default: $::os_service_default.
#
#  [*object_buffer_dir*]
#    (Optional) The local directory where uploads will be staged before they are
#    transferred into S3.
#    Default: $::os_service_default.
#
#  [*thread_pools*]
#    (Optional) The number of thread pools to perform a multipart upload in S3.
#    Default: $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glance::backend::s3(
  $access_key,
  $secret_key,
  $host,
  $bucket,
  $bucket_url_format        = $::os_service_default,
  $create_bucket_on_put     = $::os_service_default,
  $large_object_size        = $::os_service_default,
  $large_object_chunk_size  = $::os_service_default,
  $object_buffer_dir        = $::os_service_default,
  $thread_pools             = $::os_service_default,
  $multi_store              = false,
) {

  warning('glance::backend::s3 is deprecated and has no effect. Glance no longer supports the s3 backend.')
}
