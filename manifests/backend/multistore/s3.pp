#
# Copyright 2021 Red Hat, Inc.
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
# == Define: glance::backend::multistore::s3
#
# Used to configure s3 backends for glance
#
# === Parameters:
#
# [*s3_store_host*]
#   (required) The host where the S3 server is listening.
#   Defaults to $::os_service_default.
#
# [*s3_store_access_key*]
#   (required) The S3 query token access key.
#   Defaults to $::os_service_default.
#
# [*s3_store_secret_key*]
#   (required) The S3 query token secret key.
#   Defaults to $::os_service_default.
#
# [*s3_store_bucket*]
#   (required) The S3 bucket to be used to store the Glance data.
#   Defaults to $::os_service_default.
#
# [*s3_store_create_bucket_on_put*]
#   (optional) Determine whether S3 should create a new bucket.
#   Defaults to $::os_service_default.
#
# [*s3_store_bucket_url_format*]
#   (optional) The S3 calling format used to determine the object.
#   Defaults to $::os_service_default.
#
# [*s3_store_large_object_size*]
#   (optional) What size, in MB, should S3 start chunking image files and do
#   a multipart upload in S3.
#   Defaults to $::os_service_default.
#
# [*s3_store_large_object_chunk_size*]
#   (optional) What multipart upload part size, in MB, should S3 use when
#   uploading parts.
#   Defaults to $::os_service_default.
#
# [*s3_store_thread_pools*]
#   (optional) The number of thread pools to perform a multipart upload in S3.
#   Defaults to $::os_service_default.
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $::os_service_default.
#
# [*manage_packages*]
#   Optional. Whether we should manage the packages.
#   Defaults to true,
#
# [*package_ensure*]
#   Optional. Desired ensure state of packages.
#   accepts latest or specific versions.
#   Defaults to present.
#
define glance::backend::multistore::s3(
  $s3_store_host,
  $s3_store_access_key,
  $s3_store_secret_key,
  $s3_store_bucket,
  $s3_store_create_bucket_on_put    = $::os_service_default,
  $s3_store_bucket_url_format       = $::os_service_default,
  $s3_store_large_object_size       = $::os_service_default,
  $s3_store_large_object_chunk_size = $::os_service_default,
  $s3_store_thread_pools            = $::os_service_default,
  $store_description                = $::os_service_default,
  $manage_packages                  = true,
  $package_ensure                   = 'present',
) {

  include glance::deps
  include glance::params

  if $manage_packages {
    ensure_packages('python-boto3', {
      'ensure' => $package_ensure,
      'name'   => $::glance::params::boto3_package_name,
      'tag'    => ['openstack','glance-package'],
    })
  }

  glance_api_config {
    "${name}/s3_store_host":                    value => $s3_store_host;
    "${name}/s3_store_access_key":              value => $s3_store_access_key, secret => true;
    "${name}/s3_store_secret_key":              value => $s3_store_secret_key, secret => true;
    "${name}/s3_store_bucket":                  value => $s3_store_bucket;
    "${name}/s3_store_create_bucket_on_put":    value => $s3_store_create_bucket_on_put;
    "${name}/s3_store_bucket_url_format":       value => $s3_store_bucket_url_format;
    "${name}/s3_store_large_object_size":       value => $s3_store_large_object_size;
    "${name}/s3_store_large_object_chunk_size": value => $s3_store_large_object_chunk_size;
    "${name}/s3_store_thread_pools":            value => $s3_store_thread_pools;
    "${name}/store_description":                value => $store_description;
  }

  glance_cache_config {
    "${name}/s3_store_host":                    value => $s3_store_host;
    "${name}/s3_store_access_key":              value => $s3_store_access_key, secret => true;
    "${name}/s3_store_secret_key":              value => $s3_store_secret_key, secret => true;
    "${name}/s3_store_bucket":                  value => $s3_store_bucket;
    "${name}/s3_store_create_bucket_on_put":    value => $s3_store_create_bucket_on_put;
    "${name}/s3_store_bucket_url_format":       value => $s3_store_bucket_url_format;
    "${name}/s3_store_large_object_size":       value => $s3_store_large_object_size;
    "${name}/s3_store_large_object_chunk_size": value => $s3_store_large_object_chunk_size;
    "${name}/s3_store_thread_pools":            value => $s3_store_thread_pools;
  }
}