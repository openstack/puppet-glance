# == class: glance::backend::swift
#
# configures the storage backend for glance
# as a swift instance
#
# === parameters:
#
# [*swift_store_user*]
#   (Required) Swift store user.
#
# [*swift_store_key*]
#   (Required) Swift store key.
#
# [*swift_store_auth_address*]
#   (Optional) The address where the Swift authentication service is listening.
#   Defaults to 'http://127.0.0.1:5000/v3/'
#
# [*swift_store_auth_project_domain_name*]
#   (Optional) Name of the domain to which the project belongs.
#   Defaults to 'Default'
#
# [*swift_store_auth_user_domain_name*]
#   (Optional) Name of the domain to which the user belongs.
#   Defaults to 'Default'
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
#   Defaults to 'internalURL'
#
# [*swift_store_region*]
#   (Optional) The region of Swift endpoint to use by Glance.
#   Defaults to $facts['os_service_default'].
#
# [*default_swift_reference*]
#   (Optional) The reference to the default swift account/backing store
#   parameters to use for adding new images. String value.
#   Defaults to 'ref1'.
#
# [*multi_store*]
#   (Optional) Boolean describing if multiple backends will be configured.
#   Defaults to false
#
# DEPRECATED PARAMETERS
#
# [*swift_store_auth_version*]
#   (Optional) The authentication version to be used.
#   Defaults to undef
#
# [*swift_store_auth_project_domain_id*]
#   (Optional) ID of the domain to which the project belongs.
#   Defaults to 'default'
#
# [*swift_store_auth_user_domain_id*]
#   (Optional) ID of the domain to which the user belongs.
#   Defaults to 'default'
#
class glance::backend::swift(
  $swift_store_user,
  $swift_store_key,
  $swift_store_auth_address             = 'http://127.0.0.1:5000/v3/',
  $swift_store_container                = $facts['os_service_default'],
  $swift_store_auth_project_domain_name = 'Default',
  $swift_store_auth_user_domain_name    = 'Default',
  $swift_store_large_object_size        = $facts['os_service_default'],
  $swift_store_large_object_chunk_size  = $facts['os_service_default'],
  $swift_store_create_container_on_put  = $facts['os_service_default'],
  $swift_store_endpoint_type            = 'internalURL',
  $swift_store_region                   = $facts['os_service_default'],
  $default_swift_reference              = 'ref1',
  Boolean $multi_store                  = false,
  # DEPRECATED PARAMETERS
  $swift_store_auth_version             = undef,
  $swift_store_auth_project_domain_id   = undef,
  $swift_store_auth_user_domain_id      = undef,
) {

  include glance::deps
  include swift::client

  warning('glance::backend::swift is deprecated. Use glance::backend::multistore::swift instead.')

  glance::backend::multistore::swift { 'glance_store':
    swift_store_user                     => $swift_store_user,
    swift_store_key                      => $swift_store_key,
    swift_store_auth_address             => $swift_store_auth_address,
    swift_store_container                => $swift_store_container,
    swift_store_auth_version             => $swift_store_auth_version,
    swift_store_auth_project_domain_name => $swift_store_auth_project_domain_name,
    swift_store_auth_user_domain_name    => $swift_store_auth_user_domain_name,
    swift_store_auth_project_domain_id   => $swift_store_auth_project_domain_id,
    swift_store_auth_user_domain_id      => $swift_store_auth_user_domain_id,
    swift_store_large_object_size        => $swift_store_large_object_size,
    swift_store_large_object_chunk_size  => $swift_store_large_object_chunk_size,
    swift_store_create_container_on_put  => $swift_store_create_container_on_put,
    swift_store_endpoint_type            => $swift_store_endpoint_type,
    swift_store_region                   => $swift_store_region,
    default_swift_reference              => $default_swift_reference,
    store_description                    => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'swift'; }
    glance_cache_config { 'glance_store/default_store': value => 'swift'; }
  }
}
