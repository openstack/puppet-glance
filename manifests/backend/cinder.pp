#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
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
# == Class: glance::backend::cinder
#
# Setup Glance to backend images into Cinder
#
# === Parameters
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service catalog.
#   Format is : separated values of the form:
#   <service_type>:<service_name>:<endpoint_type> (string value)
#   Defaults to $facts['os_service_default'].
#
# [*cinder_endpoint_template*]
#   (optional) Override service catalog lookup with template for cinder endpoint.
#   Should be a valid URL. Example: 'http://localhost:8776/v1/%(project_id)s'
#   Defaults to $facts['os_service_default'].
#
# [*cinder_ca_certificates_file*]
#   (optional) Location of ca certificate file to use for cinder client requests.
#   Should be a valid ca certificate file
#   Defaults to $facts['os_service_default'].
#
# [*cinder_http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Should be a valid integer
#   Defaults to $facts['os_service_default'].
#
# [*cinder_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to cinder.
#   Should be a valid boolean value
#   Defaults to $facts['os_service_default'].
#
# [*cinder_store_auth_address*]
#   (optional) A valid authentication service address.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_store_project_name*]
#   (optional) Project name where the image volume is stored in cinder.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_store_user_name*]
#   (optional) User name to authenticate against cinder.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_store_password*]
#   (optional) A valid password for the user specified by `cinder_store_user_name'
#   Defaults to $facts['os_service_default'].
#
# [*cinder_os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glance::backend::cinder(
  $cinder_ca_certificates_file = $facts['os_service_default'],
  $cinder_api_insecure         = $facts['os_service_default'],
  $cinder_catalog_info         = $facts['os_service_default'],
  $cinder_endpoint_template    = $facts['os_service_default'],
  $cinder_http_retries         = $facts['os_service_default'],
  $cinder_store_auth_address   = $facts['os_service_default'],
  $cinder_store_project_name   = $facts['os_service_default'],
  $cinder_store_user_name      = $facts['os_service_default'],
  $cinder_store_password       = $facts['os_service_default'],
  $cinder_os_region_name       = 'RegionOne',
  Boolean $multi_store         = false,
) {

  include glance::deps

  warning('glance::backend::cinder is deprecated. Use glance::backend::multistore::cinder instead.')

  glance::backend::multistore::cinder { 'glance_store':
    cinder_api_insecure         => $cinder_api_insecure,
    cinder_catalog_info         => $cinder_catalog_info,
    cinder_http_retries         => $cinder_http_retries,
    cinder_endpoint_template    => $cinder_endpoint_template,
    cinder_ca_certificates_file => $cinder_ca_certificates_file,
    cinder_store_auth_address   => $cinder_store_auth_address,
    cinder_store_project_name   => $cinder_store_project_name,
    cinder_store_user_name      => $cinder_store_user_name,
    cinder_store_password       => $cinder_store_password,
    cinder_os_region_name       => $cinder_os_region_name,
    store_description           => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'cinder'; }
    glance_cache_config { 'glance_store/default_store': value => 'cinder'; }
  }
}
