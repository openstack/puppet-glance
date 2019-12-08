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
#   Location where dist images are stored when the backend type is file.
#   Defaults to $::os_service_default.
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $::os_service_default.
#
define glance::backend::multistore::file(
  $filesystem_store_datadir = $::os_service_default,
  $store_description        = $::os_service_default,
) {

  include glance::deps

  glance_api_config {
    "${name}/filesystem_store_datadir": value => $filesystem_store_datadir;
    "${name}/store_description":        value => $store_description;
  }

  glance_cache_config {
    "${name}/filesystem_store_datadir": value => $filesystem_store_datadir;
  }

  create_resources('glance_api_config', {})
  create_resources('glance_cache_config', {})
}
