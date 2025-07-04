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
# == Define: glance::backend::multistore::file
#
# Used to configure file backends for glance
#
# === Parameters:
#
# [*filesystem_store_datadir*]
#   (optional) Directory where dist images are stored.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_metadata_file*]
#   (optional) Filesystem store metadata file.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_file_perm*]
#   (optional) File access permissions for the image files.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_store_chunk_size*]
#   (optional) Chunk size, in bytes.
#   Defaults to $facts['os_service_default'].
#
# [*filesystem_thin_provisioning*]
#   (optional) Boolean describing if thin provisioning is enabled or not
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
# [*filesystem_store_datadirs*]
#   (optional) List of directories where dist images are stored. When using
#   multiple directories, each directory can be given an optional priority,
#   which is an integer that is concatenated to the directory path with
#   a colon.
#   Defaults to undef
#
define glance::backend::multistore::file(
  $filesystem_store_datadir       = $facts['os_service_default'],
  $filesystem_store_metadata_file = $facts['os_service_default'],
  $filesystem_store_file_perm     = $facts['os_service_default'],
  $filesystem_store_chunk_size    = $facts['os_service_default'],
  $filesystem_thin_provisioning   = $facts['os_service_default'],
  $store_description              = $facts['os_service_default'],
  $weight                         = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $filesystem_store_datadirs      = undef,
) {

  include glance::deps

  if $filesystem_store_datadirs != undef {
    warning('The filesystem_store_datadirs parameter is deprecated')
    $filesystem_store_datadirs_real = $filesystem_store_datadirs
  } else {
    $filesystem_store_datadirs_real = $facts['os_service_default']
  }

  if !is_service_default($filesystem_store_datadir) and !is_service_default($filesystem_store_datadirs_real) {
    fail('filesystem_store_datadir and filesystem_store_datadirs are mutually exclusive.')
  }

  glance_api_config {
    "${name}/filesystem_store_datadir":       value => $filesystem_store_datadir;
    "${name}/filesystem_store_datadirs":      value => $filesystem_store_datadirs_real;
    "${name}/filesystem_store_chunk_size":    value => $filesystem_store_chunk_size;
    "${name}/filesystem_thin_provisioning":   value => $filesystem_thin_provisioning;
    "${name}/store_description":              value => $store_description;
    "${name}/weight":                         value => $weight;
  }

  if $name != 'glance_store' {
    # NOTE(tkajinam): This logic is required to avoid conflict with glance::api
    glance_api_config {
      "${name}/filesystem_store_metadata_file": value => $filesystem_store_metadata_file;
      "${name}/filesystem_store_file_perm":     value => $filesystem_store_file_perm;
    }
    glance_cache_config {
      "${name}/filesystem_store_metadata_file": value => $filesystem_store_metadata_file;
      "${name}/filesystem_store_file_perm":     value => $filesystem_store_file_perm;
    }
  }

  glance_cache_config {
    "${name}/filesystem_store_datadir":     value => $filesystem_store_datadir;
    "${name}/filesystem_store_datadirs":    value => $filesystem_store_datadirs_real;
    "${name}/filesystem_store_chunk_size":  value => $filesystem_store_chunk_size;
    "${name}/filesystem_thin_provisioning": value => $filesystem_thin_provisioning;
    "${name}/weight":                       value => $weight;
  }
}
