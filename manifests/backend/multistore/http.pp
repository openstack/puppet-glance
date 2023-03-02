#
# Copyright 2020 Red Hat, Inc.
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
# == Define: glance::backend::multistore::http
#
# configures the storage backend for glance with a remote http server
#
# === Parameters:
#
# [*https_ca_certificates_file*]
#   Optional. Path to the CA bundle file.
#   Defaults to $facts['os_service_default'].
#
# [*https_insecure*]
#   Optional. Set verification of the remote server certificate.
#   Defaults to $facts['os_service_default'].
#
# [*http_proxy_information*]
#   Optional. The http/https proxy information to be used to connect to the
#   remote server.
#   Defaults to $facts['os_service_default']
#
define glance::backend::multistore::http(
  $https_ca_certificates_file = $facts['os_service_default'],
  $https_insecure             = $facts['os_service_default'],
  $http_proxy_information     = $facts['os_service_default'],
) {

  include glance::deps
  include glance::params

  # Glance only accepts a single http store. The following dummy resource
  # has been added to make sure that only one http store is defined.
  if defined(Exec['dummy-glance-multistore-http']){
    fail('Glance accepts only one http store.')
  } else {
    exec { 'dummy-glance-multistore-http':
      command => '/bin/true'
    }
  }

  glance_api_config {
    "${name}/https_ca_certificates_file": value => $https_ca_certificates_file;
    "${name}/https_insecure":             value => $https_insecure;
    "${name}/http_proxy_information":     value => join(any2array($http_proxy_information), ',');
  }
}
