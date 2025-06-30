#
# Copyright 2019 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Define: glance::backend::swift
#
# configures the storage backend for glance
# as a swift instance
#
# === Parameters:
#
# [*swift_store_user*]
#   Required. Swift store user.
#
# [*swift_store_key*]
#   Required. Swift store key.
#
# [*swift_store_auth_address*]
#   Optional. Default: 'http://127.0.0.1:5000/v3/'
#
# [*swift_store_auth_project_domain_id*]
#   Optional. Useful when keystone auth is version 3. Default: default
#
# [*swift_store_auth_user_domain_id*]
#   Optional. Useful when keystone auth is version 3. Default: default
#
# [*swift_store_container*]
#   Optional. Default: $facts['os_service_default'].
#
# [*swift_store_large_object_size*]
#   Optional. What size, in MB, should Glance start chunking image files
#   and do a large object manifest in Swift?
#   Default: $facts['os_service_default'].
#
# [*swift_store_large_object_chunk_size*]
#   Optional. When doing a large object manifest, what size, in MB, should
#   Glance write chunks to Swift? This amount of data is written
#   to a temporary disk buffer during the process of chunking.
#   Default: $facts['os_service_default'].
#
# [*swift_store_create_container_on_put*]
#   Optional. Default: $facts['os_service_default'].
#
# [*swift_store_endpoint_type*]
#   Optional. Endpoint type of Swift service.
#   Default: 'internalURL'
#
# [*swift_store_service_type*]
#   Optional. Type of the swift service to use.
#   Default: $facts['os_service_default'].
#
# [*swift_store_region*]
#   Optional. The region of Swift endpoint to use by Glance.
#   Default: $facts['os_service_default'].
#
# [*default_swift_reference*]
#   Optional. The reference to the default swift
#   account/backing store parameters to use for adding
#   new images. String value.
#   Default: 'ref1'.
#
# [*swift_buffer_on_upload*]
#   Optional. Buffer image segments before upload to Swift.
#   Default: $facts['os_service_default'].
#
# [*swift_upload_buffer_dir*]
#   Optional. Directory to buffer image segments before upload to Swift.
#   Default: $facts['os_service_default'].
#
# [*swift_store_retry_get_count*]
#   Optional. The number of times a Swift download will be retried before
#   the request fails.
#   Defaults to $facts['os_service_default']
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $facts['os_service_default'].
#
# [*weight*]
#   (optional) Define a relative weight for this store over any others that
#   are configured.
#   Defaults to $facts['os_service_default'].
#
# DEPRECATED PARAMETERS
#
# [*swift_store_config_file*]
#   Optional. Default: '/etc/glance/glance-swift.conf'
#
# [*swift_store_auth_version*]
#   Optional. Default: undef
#
define glance::backend::multistore::swift(
  $swift_store_user,
  $swift_store_key,
  $swift_store_auth_address            = 'http://127.0.0.1:5000/v3/',
  $swift_store_container               = $facts['os_service_default'],
  $swift_store_auth_project_domain_id  = 'default',
  $swift_store_auth_user_domain_id     = 'default',
  $swift_store_large_object_size       = $facts['os_service_default'],
  $swift_store_large_object_chunk_size = $facts['os_service_default'],
  $swift_store_create_container_on_put = $facts['os_service_default'],
  $swift_store_endpoint_type           = 'internalURL',
  $swift_store_service_type            = $facts['os_service_default'],
  $swift_store_region                  = $facts['os_service_default'],
  $default_swift_reference             = 'ref1',
  $swift_buffer_on_upload              = $facts['os_service_default'],
  $swift_upload_buffer_dir             = $facts['os_service_default'],
  $swift_store_retry_get_count         = $facts['os_service_default'],
  $store_description                   = $facts['os_service_default'],
  $weight                              = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $swift_store_config_file             = undef,
  $swift_store_auth_version            = undef,
) {

  include glance::deps
  include swift::client

  Class['swift::client'] -> Anchor['glance::install::end']
  Anchor['swift::service::end'] -> Anchor['glance::service::end']

  if $swift_store_config_file != undef {
    warning('The swift_store_config_file parameter is deprecated')
    $swift_store_config_file_real = $swift_store_config_file
  } else {
    $swift_store_config_file_real = '/etc/glance/glance-swift.conf'
  }

  if $swift_store_auth_version != undef {
    warning('The swift_store_auth_version parameter is deprecated')
  }

  glance_api_config {
    "${name}/swift_store_region":                  value => $swift_store_region;
    "${name}/swift_store_container":               value => $swift_store_container;
    "${name}/swift_store_create_container_on_put": value => $swift_store_create_container_on_put;
    "${name}/swift_store_large_object_size":       value => $swift_store_large_object_size;
    "${name}/swift_store_large_object_chunk_size": value => $swift_store_large_object_chunk_size;
    "${name}/swift_store_endpoint_type":           value => $swift_store_endpoint_type;
    "${name}/swift_store_service_type":            value => $swift_store_service_type;
    "${name}/swift_store_config_file":             value => $swift_store_config_file_real;
    "${name}/default_swift_reference":             value => $default_swift_reference;
    "${name}/swift_buffer_on_upload":              value => $swift_buffer_on_upload;
    "${name}/swift_upload_buffer_dir":             value => $swift_upload_buffer_dir;
    "${name}/swift_store_retry_get_count":         value => $swift_store_retry_get_count;
    "${name}/store_description":                   value => $store_description;
    "${name}/weight":                              value => $weight;
  }
  glance_cache_config {
    "${name}/swift_store_region":                  value => $swift_store_region;
    "${name}/swift_store_container":               value => $swift_store_container;
    "${name}/swift_store_create_container_on_put": value => $swift_store_create_container_on_put;
    "${name}/swift_store_large_object_size":       value => $swift_store_large_object_size;
    "${name}/swift_store_large_object_chunk_size": value => $swift_store_large_object_chunk_size;
    "${name}/swift_store_endpoint_type":           value => $swift_store_endpoint_type;
    "${name}/swift_store_service_type":            value => $swift_store_service_type;
    "${name}/swift_store_config_file":             value => $swift_store_config_file_real;
    "${name}/default_swift_reference":             value => $default_swift_reference;
    "${name}/swift_buffer_on_upload":              value => $swift_buffer_on_upload;
    "${name}/swift_upload_buffer_dir":             value => $swift_upload_buffer_dir;
    "${name}/swift_store_retry_get_count":         value => $swift_store_retry_get_count;
    "${name}/weight":                              value => $weight;
  }

  glance_swift_config {
    "${default_swift_reference}/user":              value => $swift_store_user;
    "${default_swift_reference}/key":               value => $swift_store_key, secret => true;
    "${default_swift_reference}/auth_address":      value => $swift_store_auth_address;
    "${default_swift_reference}/auth_version":      value => pick($swift_store_auth_version, $facts['os_service_default']);
    "${default_swift_reference}/user_domain_id":    value => $swift_store_auth_user_domain_id;
    "${default_swift_reference}/project_domain_id": value => $swift_store_auth_project_domain_id;
  }
}
