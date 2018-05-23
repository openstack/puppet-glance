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
#    Optional. Default: 'http://127.0.0.1:5000/v2.0/'
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
  $swift_store_auth_address            = 'http://127.0.0.1:5000/v2.0/',
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
  Class['swift::client'] -> Anchor['glance::install::end']
  Service<| tag == 'swift-service' |> -> Service['glance-api']

  glance_api_config {
    'glance_store/swift_store_region':         value => $swift_store_region;
    'glance_store/swift_store_container':      value => $swift_store_container;
    'glance_store/swift_store_create_container_on_put':
      value => $swift_store_create_container_on_put;
    'glance_store/swift_store_large_object_size':
      value => $swift_store_large_object_size;
    'glance_store/swift_store_large_object_chunk_size':
      value => $swift_store_large_object_chunk_size;
    'glance_store/swift_store_endpoint_type':
      value => $swift_store_endpoint_type;

    'glance_store/swift_store_config_file':    value => '/etc/glance/glance-swift.conf';
    'glance_store/default_swift_reference':    value => $default_swift_reference;
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'swift'; }
  }

  glance_swift_config {
    "${default_swift_reference}/user":         value => $swift_store_user;
    "${default_swift_reference}/key":          value => $swift_store_key;
    "${default_swift_reference}/auth_address": value => $swift_store_auth_address;
    "${default_swift_reference}/auth_version": value => $swift_store_auth_version;
    "${default_swift_reference}/user_domain_id": value => $swift_store_auth_user_domain_id;
    "${default_swift_reference}/project_domain_id": value => $swift_store_auth_project_domain_id;
  }

}
