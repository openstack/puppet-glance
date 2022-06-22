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
#   Defaults to $::os_service_default.
#
# [*filesystem_store_datadirs*]
#   (optional) List of directories where dist images are stored. When using
#   multiple directoris, each directory can be given an optional priority,
#   which is an integer that is concatenated to the directory path with
#   a colon.
#   Defaults to $::os_service_default.
#
# [*filesystem_store_metadata_file*]
#   (optional) Filesystem store metadata file.
#   Defaults to $::os_service_default.
#
# [*filesystem_store_file_perm*]
#   (optional) File access permissions for the image files.
#   Defaults to $::os_service_default.
#
# [*filesystem_store_chunk_size*]
#   (optional) Chunk size, in bytes.
#   Defaults to $::os_service_default.
#
# [*filesystem_thin_provisioning*]
#   (optional) Boolean describing if thin provisioning is enabled or not
#   Defaults to $::os_service_default
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $::os_service_default.
#
define glance::backend::multistore::file(
  $filesystem_store_datadir       = $::os_service_default,
  $filesystem_store_datadirs      = $::os_service_default,
  $filesystem_store_metadata_file = $::os_service_default,
  $filesystem_store_file_perm     = $::os_service_default,
  $filesystem_store_chunk_size    = $::os_service_default,
  $filesystem_thin_provisioning   = $::os_service_default,
  $store_description              = $::os_service_default,
) {

  include glance::deps

  if !is_service_default($filesystem_store_datadir) and !is_service_default($filesystem_store_datadirs) {
    fail('filesystem_store_datadir and filesystem_store_datadirs are mutually exclusive.')
  }

  glance_api_config {
    "${name}/filesystem_store_datadir":       value => $filesystem_store_datadir;
    "${name}/filesystem_store_datadirs":      value => $filesystem_store_datadirs;
    "${name}/filesystem_store_chunk_size":    value => $filesystem_store_chunk_size;
    "${name}/filesystem_thin_provisioning":   value => $filesystem_thin_provisioning;
    "${name}/store_description":              value => $store_description;
  }

  if $name != 'glance_store' {
    # NOTE(tkajinam): This logic is required to avoid conflict with glance::api
    glance_api_config {
      "${name}/filesystem_store_metadata_file": value => $filesystem_store_metadata_file;
      "${name}/filesystem_store_file_perm":     value => $filesystem_store_file_perm;
    }
  }

  glance_cache_config {
    "${name}/filesystem_store_datadir":  value => $filesystem_store_datadir;
    "${name}/filesystem_store_datadirs": value => $filesystem_store_datadirs;
  }
}
