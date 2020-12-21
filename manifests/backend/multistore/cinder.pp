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
# == Define: glance::backend::multistore::cinder
#
# Used to configure cinder backends for glance
#
# === Parameters
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service catalog.
#   Format is : separated values of the form:
#   <service_type>:<service_name>:<endpoint_type> (string value)
#   Defaults to $::os_service_default.
#
# [*cinder_endpoint_template*]
#   (optional) Override service catalog lookup with template for cinder endpoint.
#   Should be a valid URL. Example: 'http://localhost:8776/v1/%(project_id)s'
#   Defaults to $::os_service_default.
#
# [*cinder_ca_certificates_file*]
#   (optional) Location of ca certicate file to use for cinder client requests.
#   Should be a valid ca certicate file
#   Defaults to $::os_service_default.
#
# [*cinder_http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Should be a valid integer
#   Defaults to $::os_service_default.
#
# [*cinder_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to cinder.
#   Should be a valid boolean value
#   Defaults to $::os_service_default.
#
# [*cinder_store_auth_address*]
#   (optional) A valid authentication service address.
#   Defaults to $::os_service_default.
#
# [*cinder_store_project_name*]
#   (optional) Project name where the image volume is stored in cinder.
#   Defaults to $::os_service_default.
#
# [*cinder_store_user_name*]
#   (optional) User name to authenticate against cinder.
#   Defaults to $::os_service_default.
#
# [*cinder_store_password*]
#   (optional) A valid password for the user specified by `cinder_store_user_name'
#   Defaults to $::os_service_default.
#
# [*cinder_os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*cinder_enforce_multipath*]
#   (optional) Enforce multipath usage when attaching a cinder volume
#   Defaults to $::os_service_default.
#
# [*cinder_use_multipath*]
#   (optional) Flag to identify multipath is supported or not in the deployment
#   Defaults to $::os_service_default.
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $::os_service_default.
#
define glance::backend::multistore::cinder(
  $cinder_ca_certificates_file = $::os_service_default,
  $cinder_api_insecure         = $::os_service_default,
  $cinder_catalog_info         = $::os_service_default,
  $cinder_endpoint_template    = $::os_service_default,
  $cinder_http_retries         = $::os_service_default,
  $cinder_store_auth_address   = $::os_service_default,
  $cinder_store_project_name   = $::os_service_default,
  $cinder_store_user_name      = $::os_service_default,
  $cinder_store_password       = $::os_service_default,
  $cinder_os_region_name       = 'RegionOne',
  $cinder_enforce_multipath    = $::os_service_default,
  $cinder_use_multipath        = $::os_service_default,
  $store_description           = $::os_service_default,
) {

  include glance::deps

  # to keep backwards compatibility
  $cinder_os_region_name_real = pick($::glance::api::os_region_name, $cinder_os_region_name)

  glance_api_config {
    "${name}/cinder_api_insecure":         value => $cinder_api_insecure;
    "${name}/cinder_catalog_info":         value => $cinder_catalog_info;
    "${name}/cinder_http_retries":         value => $cinder_http_retries;
    "${name}/cinder_endpoint_template":    value => $cinder_endpoint_template;
    "${name}/cinder_ca_certificates_file": value => $cinder_ca_certificates_file;
    "${name}/cinder_store_auth_address":   value => $cinder_store_auth_address;
    "${name}/cinder_store_project_name":   value => $cinder_store_project_name;
    "${name}/cinder_store_user_name":      value => $cinder_store_user_name;
    "${name}/cinder_store_password":       value => $cinder_store_password, secret => true;
    "${name}/cinder_os_region_name":       value => $cinder_os_region_name_real;
    "${name}/cinder_enforce_multipath":    value => $cinder_enforce_multipath;
    "${name}/cinder_use_multipath":        value => $cinder_use_multipath;
    "${name}/store_description":           value => $store_description;
  }

  glance_cache_config {
    "${name}/cinder_api_insecure":         value => $cinder_api_insecure;
    "${name}/cinder_catalog_info":         value => $cinder_catalog_info;
    "${name}/cinder_http_retries":         value => $cinder_http_retries;
    "${name}/cinder_endpoint_template":    value => $cinder_endpoint_template;
    "${name}/cinder_ca_certificates_file": value => $cinder_ca_certificates_file;
    "${name}/cinder_store_auth_address":   value => $cinder_store_auth_address;
    "${name}/cinder_store_project_name":   value => $cinder_store_project_name;
    "${name}/cinder_store_user_name":      value => $cinder_store_user_name;
    "${name}/cinder_store_password":       value => $cinder_store_password, secret => true;
    "${name}/cinder_os_region_name":       value => $cinder_os_region_name_real;
    "${name}/cinder_enforce_multipath":    value => $cinder_enforce_multipath;
    "${name}/cinder_use_multipath":        value => $cinder_use_multipath;
  }

  create_resources('glance_api_config', {})
  create_resources('glance_cache_config', {})
}
