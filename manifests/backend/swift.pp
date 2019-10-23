# == class: glance::backend::swift
#
# configures the storage backend for glance
# as a swift instance
#
# === parameters:
#
#  [*swift_store_user*]
#    Required. Swift store user.
#
#  [*swift_store_key*]
#    Required. Swift store key.
#
#  [*swift_store_auth_address*]
#    Optional. Default: 'http://127.0.0.1:5000/v3/'
#
#  [*swift_store_auth_project_domain_id*]
#    Optional. Useful when keystone auth is version 3. Default: default
#
#  [*swift_store_auth_user_domain_id*]
#    Optional. Useful when keystone auth is version 3. Default: default
#
#  [*swift_store_container*]
#    Optional. Default: $::os_service_default.
#
#  [*swift_store_auth_version*]
#    Optional. Default: '2'
#
#  [*swift_store_large_object_size*]
#    Optional. What size, in MB, should Glance start chunking image files
#    and do a large object manifest in Swift?
#    Default: $::os_service_default.
#
#  [*swift_store_large_object_chunk_size*]
#    Optional. When doing a large object manifest, what size, in MB, should
#    Glance write chunks to Swift? This amount of data is written
#    to a temporary disk buffer during the process of chunking.
#    Default: $::os_service_default.
#
#  [*swift_store_create_container_on_put*]
#    Optional. Default: $::os_service_default.
#
#  [*swift_store_endpoint_type*]
#    Optional. Default: 'internalURL'
#
#  [*swift_store_region*]
#    Optional. Default: $::os_service_default.
#
#  [*default_swift_reference*]
#    Optional. The reference to the default swift
#    account/backing store parameters to use for adding
#    new images. String value.
#    Default to 'ref1'.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glance::backend::swift(
  $swift_store_user,
  $swift_store_key,
  $swift_store_auth_address            = 'http://127.0.0.1:5000/v3/',
  $swift_store_container               = $::os_service_default,
  $swift_store_auth_version            = '2',
  $swift_store_auth_project_domain_id  = 'default',
  $swift_store_auth_user_domain_id     = 'default',
  $swift_store_large_object_size       = $::os_service_default,
  $swift_store_large_object_chunk_size = $::os_service_default,
  $swift_store_create_container_on_put = $::os_service_default,
  $swift_store_endpoint_type           = 'internalURL',
  $swift_store_region                  = $::os_service_default,
  $default_swift_reference             = 'ref1',
  $multi_store                         = false,
) {

  include ::glance::deps
  include ::swift::client

  warning('glance::backend::swift is deprecated. Use glance::backend::multistore::swift instead.')

  glance::backend::multistore::swift { 'glance_store':
    swift_store_user                    => $swift_store_user,
    swift_store_key                     => $swift_store_key,
    swift_store_auth_address            => $swift_store_auth_address,
    swift_store_container               => $swift_store_container,
    swift_store_auth_version            => $swift_store_auth_version,
    swift_store_auth_project_domain_id  => $swift_store_auth_project_domain_id,
    swift_store_auth_user_domain_id     => $swift_store_auth_user_domain_id,
    swift_store_large_object_size       => $swift_store_large_object_size,
    swift_store_large_object_chunk_size => $swift_store_large_object_chunk_size,
    swift_store_create_container_on_put => $swift_store_create_container_on_put,
    swift_store_endpoint_type           => $swift_store_endpoint_type,
    swift_store_region                  => $swift_store_region,
    swift_store_config_file             => '/etc/glance/glance-swift.conf',
    default_swift_reference             => $default_swift_reference,
    store_description                   => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'swift'; }
  }
}
