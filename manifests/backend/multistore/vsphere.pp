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
# == Define: glance::backend::multistore::vsphere
#
# DEPRECATED !!
# Used to configure vsphere backends for glance
#
# === Parameters
#
# [*vmware_insecure*]
#   (optional) If true, the ESX/vCenter server certificate is not verified.
#   If false, then the default CA truststore is used for verification.
#   This option is ignored if "vcenter_ca_file" is set.
#   Defaults to 'True'.
#
# [*vmware_ca_file*]
#   (optional) The name of the CA bundle file which will be used in
#   verifying vCenter server certificate. If parameter is not set
#   then system truststore is used. If parameter is set,
#   vcenter_insecure value is ignored.
#   Defaults to $facts['os_service_default'].
#
# [*vmware_datastores*]
#   (Multi-valued) A list of datastores where the image
#   can be stored. This option may be specified multiple times
#   for specifying multiple datastores. The datastore name should
#   be specified after its datacenter path, separated by ":".
#   An optional weight may be given after the datastore name,
#   separated again by ":". Thus, the required format
#   becomes <datacenter_path>:<datastore_name>:<optional_weight>.
#   When adding an image, the datastore with highest weight will be selected,
#   unless there is not enough free space available in cases where the image
#   size is already known. If no weight is given, it is assumed to be
#   zero and the directory will be considered for selection last.
#   If multiple datastores have the same weight, then the one with the most
#   free space available is selected.
#   Defaults to $facts['os_service_default'].
#
# [*vmware_server_host*]
#   (required) vCenter/ESXi Server target system.
#   Should be a valid an IP address or a DNS name.
#
# [*vmware_server_username*]
#   (required) Username for authenticating with vCenter/ESXi server.
#
# [*vmware_server_password*]
#   (required) Password for authenticating with vCenter/ESXi server.
#
# [*vmware_store_image_dir*]
#   (required) The name of the directory where the glance images will be stored
#   in the VMware datastore.
#
# [*vmware_task_poll_interval*]
#   (optional) The interval used for polling remote tasks invoked on
#   vCenter/ESXi server.
#   Defaults to $facts['os_service_default'].
#
# [*vmware_api_retry_count*]
#   (optional) Number of times VMware ESX/VC server API must be retried upon
#   connection related issues.
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
define glance::backend::multistore::vsphere(
  $vmware_server_host,
  $vmware_server_username,
  $vmware_server_password,
  $vmware_store_image_dir,
  $vmware_ca_file            = $facts['os_service_default'],
  $vmware_datastores         = $facts['os_service_default'],
  $vmware_insecure           = 'True',
  $vmware_task_poll_interval = $facts['os_service_default'],
  $vmware_api_retry_count    = $facts['os_service_default'],
  $store_description         = $facts['os_service_default'],
  $weight                    = $facts['os_service_default'],
) {

  include glance::deps

  warning("The VMWare Datastore store driver support has been deprecated. \
It will be removed in a future release.")

  glance_api_config {
    "${name}/vmware_insecure":           value => $vmware_insecure;
    "${name}/vmware_ca_file":            value => $vmware_ca_file;
    "${name}/vmware_server_host":        value => $vmware_server_host;
    "${name}/vmware_server_username":    value => $vmware_server_username;
    "${name}/vmware_server_password":    value => $vmware_server_password, secret => true;
    "${name}/vmware_store_image_dir":    value => $vmware_store_image_dir;
    "${name}/vmware_task_poll_interval": value => $vmware_task_poll_interval;
    "${name}/vmware_api_retry_count":    value => $vmware_api_retry_count;
    "${name}/vmware_datastores":         value => $vmware_datastores;
    "${name}/store_description":         value => $store_description;
    "${name}/weight":                    value => $weight;
  }

  glance_cache_config {
    "${name}/vmware_insecure":           value => $vmware_insecure;
    "${name}/vmware_ca_file":            value => $vmware_ca_file;
    "${name}/vmware_server_host":        value => $vmware_server_host;
    "${name}/vmware_server_username":    value => $vmware_server_username;
    "${name}/vmware_server_password":    value => $vmware_server_password, secret => true;
    "${name}/vmware_store_image_dir":    value => $vmware_store_image_dir;
    "${name}/vmware_task_poll_interval": value => $vmware_task_poll_interval;
    "${name}/vmware_api_retry_count":    value => $vmware_api_retry_count;
    "${name}/vmware_datastores":         value => $vmware_datastores;
    "${name}/weight":                    value => $weight;
  }
}
