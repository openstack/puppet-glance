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
# [*cinder_store_user_domain_name*]
#   (optional) Domain of the user to authenticate against cinder.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_store_project_domain_name*]
#   (optional) Domain of the project to authenticate against cinder.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*cinder_volume_type*]
#   (Optional) The volume type to be used to create image volumes in cinder.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_enforce_multipath*]
#   (optional) Enforce multipath usage when attaching a cinder volume
#   Defaults to $facts['os_service_default'].
#
# [*cinder_use_multipath*]
#   (optional) Flag to identify multipath is supported or not in the deployment
#   Defaults to $facts['os_service_default'].
#
# [*cinder_mount_point_base*]
#   (Optional) When glance uses cinder as store and cinder backend is NFS,
#   the mount point would be required to be set with this parameter.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_do_extend_attached*]
#   (Optional) If this is set to True, glance will perform an extend operation
#   on the attached volume.
#   Defaults to $facts['os_service_default'].
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
define glance::backend::multistore::cinder(
  $cinder_ca_certificates_file      = $facts['os_service_default'],
  $cinder_api_insecure              = $facts['os_service_default'],
  $cinder_catalog_info              = $facts['os_service_default'],
  $cinder_endpoint_template         = $facts['os_service_default'],
  $cinder_http_retries              = $facts['os_service_default'],
  $cinder_store_auth_address        = $facts['os_service_default'],
  $cinder_store_project_name        = $facts['os_service_default'],
  $cinder_store_user_name           = $facts['os_service_default'],
  $cinder_store_password            = $facts['os_service_default'],
  $cinder_store_user_domain_name    = $facts['os_service_default'],
  $cinder_store_project_domain_name = $facts['os_service_default'],
  $cinder_os_region_name            = 'RegionOne',
  $cinder_volume_type               = $facts['os_service_default'],
  $cinder_enforce_multipath         = $facts['os_service_default'],
  $cinder_use_multipath             = $facts['os_service_default'],
  $cinder_mount_point_base          = $facts['os_service_default'],
  $cinder_do_extend_attached        = $facts['os_service_default'],
  $store_description                = $facts['os_service_default'],
  $weight                           = $facts['os_service_default'],
) {

  include glance::deps

  glance_api_config {
    "${name}/cinder_api_insecure":              value => $cinder_api_insecure;
    "${name}/cinder_catalog_info":              value => $cinder_catalog_info;
    "${name}/cinder_http_retries":              value => $cinder_http_retries;
    "${name}/cinder_endpoint_template":         value => $cinder_endpoint_template;
    "${name}/cinder_ca_certificates_file":      value => $cinder_ca_certificates_file;
    "${name}/cinder_store_auth_address":        value => $cinder_store_auth_address;
    "${name}/cinder_store_project_name":        value => $cinder_store_project_name;
    "${name}/cinder_store_user_name":           value => $cinder_store_user_name;
    "${name}/cinder_store_password":            value => $cinder_store_password, secret => true;
    "${name}/cinder_store_user_domain_name":    value => $cinder_store_user_domain_name;
    "${name}/cinder_store_project_domain_name": value => $cinder_store_project_domain_name;
    "${name}/cinder_os_region_name":            value => $cinder_os_region_name;
    "${name}/cinder_volume_type":               value => $cinder_volume_type;
    "${name}/cinder_enforce_multipath":         value => $cinder_enforce_multipath;
    "${name}/cinder_use_multipath":             value => $cinder_use_multipath;
    "${name}/cinder_mount_point_base":          value => $cinder_mount_point_base;
    "${name}/cinder_do_extend_attached":        value => $cinder_do_extend_attached;
    "${name}/store_description":                value => $store_description;
    "${name}/weight":                           value => $weight;
  }

  glance_cache_config {
    "${name}/cinder_api_insecure":              value => $cinder_api_insecure;
    "${name}/cinder_catalog_info":              value => $cinder_catalog_info;
    "${name}/cinder_http_retries":              value => $cinder_http_retries;
    "${name}/cinder_endpoint_template":         value => $cinder_endpoint_template;
    "${name}/cinder_ca_certificates_file":      value => $cinder_ca_certificates_file;
    "${name}/cinder_store_auth_address":        value => $cinder_store_auth_address;
    "${name}/cinder_store_project_name":        value => $cinder_store_project_name;
    "${name}/cinder_store_user_name":           value => $cinder_store_user_name;
    "${name}/cinder_store_password":            value => $cinder_store_password, secret => true;
    "${name}/cinder_store_project_domain_name": value => $cinder_store_project_domain_name;
    "${name}/cinder_store_user_domain_name":    value => $cinder_store_user_domain_name;
    "${name}/cinder_os_region_name":            value => $cinder_os_region_name;
    "${name}/cinder_volume_type":               value => $cinder_volume_type;
    "${name}/cinder_enforce_multipath":         value => $cinder_enforce_multipath;
    "${name}/cinder_use_multipath":             value => $cinder_use_multipath;
    "${name}/cinder_mount_point_base":          value => $cinder_mount_point_base;
    "${name}/cinder_do_extend_attached":        value => $cinder_do_extend_attached;
    "${name}/weight":                           value => $weight;
  }
}
