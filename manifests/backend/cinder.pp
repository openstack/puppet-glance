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
#   Defaults to $::os_service_default.
#
# [*cinder_endpoint_template*]
#   (optional) Override service catalog lookup with template for cinder endpoint.
#   Should be a valid URL. Example: 'http://localhost:8776/v1/%(project_id)s'
#   Defaults to $::os_service_default.
#
# [*os_region_name*]
#   (optional) The os_region_name parameter is deprecated and has no effect.
#   Use glance::api::os_region_name instead.
#   Defaults to 'undef'
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
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
# [*glare_enabled*]
#   (optional) Whether enabled Glance Glare API.
#   Defaults to false
#
class glance::backend::cinder(
  $os_region_name              = undef,
  $cinder_ca_certificates_file = $::os_service_default,
  $cinder_api_insecure         = $::os_service_default,
  $cinder_catalog_info         = $::os_service_default,
  $cinder_endpoint_template    = $::os_service_default,
  $cinder_http_retries         = $::os_service_default,
  $multi_store                 = false,
  $glare_enabled               = false,
) {

  include ::glance::deps

  if $os_region_name {
    notice('The os_region_name parameter is deprecated and has no effect. Use glance::api::os_region_name instead.')
  }

  glance_api_config {
    'glance_store/cinder_api_insecure':           value => $cinder_api_insecure;
    'glance_store/cinder_catalog_info':           value => $cinder_catalog_info;
    'glance_store/cinder_http_retries':           value => $cinder_http_retries;
    'glance_store/cinder_endpoint_template':      value => $cinder_endpoint_template;
    'glance_store/cinder_ca_certificates_file':   value => $cinder_ca_certificates_file;
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'cinder'; }
    if $glare_enabled {
      glance_glare_config { 'glance_store/default_store': value => 'cinder'; }
    }
  }

  glance_cache_config {
    'glance_store/cinder_api_insecure':           value => $cinder_api_insecure;
    'glance_store/cinder_catalog_info':           value => $cinder_catalog_info;
    'glance_store/cinder_http_retries':           value => $cinder_http_retries;
    'glance_store/cinder_endpoint_template':      value => $cinder_endpoint_template;
    'glance_store/cinder_ca_certificates_file':   value => $cinder_ca_certificates_file;
  }

  if $glare_enabled {
    glance_glare_config {
      'glance_store/cinder_api_insecure':         value => $cinder_api_insecure;
      'glance_store/cinder_catalog_info':         value => $cinder_catalog_info;
      'glance_store/cinder_http_retries':         value => $cinder_http_retries;
      'glance_store/cinder_endpoint_template':    value => $cinder_endpoint_template;
      'glance_store/cinder_ca_certificates_file': value => $cinder_ca_certificates_file;
    }
  }

}
