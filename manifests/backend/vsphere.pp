#
# Copyright (C) 2014 Mirantis
#
# Author: Steapn Rogov <srogov@mirantis.com>
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
# == Class: glance::backend::vsphere
#
# Setup Glance to backend images into VMWare vCenter/ESXi
#
# === Parameters
#
# [*vcenter_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to vCenter/ESXi.
#   Should be a valid string boolean value
#   Defaults to 'True'
#
# [*vcenter_ca_file*]
#   (optional) The name of the CA bundle file which will be used in
#   verifying vCenter server certificate. If parameter is not set
#   then system truststore is used. If parameter is set, vcenter_api_insecure
#   value is ignored.
#   Defaults to $::os_service_default.
#
# [*vcenter_host*]
#   (required) vCenter/ESXi Server target system.
#   Should be a valid an IP address or a DNS name.
#
# [*vcenter_user*]
#   (required) Username for authenticating with vCenter/ESXi server.
#
# [*vcenter_password*]
#   (required) Password for authenticating with vCenter/ESXi server.
#
# [*vcenter_datacenter*]
#   (required) Inventory path to a datacenter.
#   If you want to use ESXi host as datastore,it should be "ha-datacenter".
#
# [*vcenter_datastore*]
#   (required) Datastore associated with the datacenter.
#
# [*vcenter_image_dir*]
#   (required) The name of the directory where the glance images will be stored
#   in the VMware datastore.
#
# [*vcenter_task_poll_interval*]
#   (optional) The interval used for polling remote tasks invoked on
#   vCenter/ESXi server.
#   Defaults to $::os_service_default.
#
# [*vcenter_api_retry_count*]
#   (optional) Number of times VMware ESX/VC server API must be retried upon
#   connection related issues.
#    Defaults to $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
# [*glare_enabled*]
#   (optional) Whether enabled Glance Glare API.
#   Defaults to false
#
class glance::backend::vsphere(
  $vcenter_host,
  $vcenter_user,
  $vcenter_password,
  $vcenter_datacenter,
  $vcenter_datastore,
  $vcenter_image_dir,
  $vcenter_ca_file            = $::os_service_default,
  $vcenter_api_insecure       = 'True',
  $vcenter_task_poll_interval = $::os_service_default,
  $vcenter_api_retry_count    = $::os_service_default,
  $multi_store                = false,
  $glare_enabled              = false,
) {

  glance_api_config {
    'glance_store/vmware_api_insecure': value       => $vcenter_api_insecure;
    'glance_store/vmware_ca_file': value            => $vcenter_ca_file;
    'glance_store/vmware_server_host': value        => $vcenter_host;
    'glance_store/vmware_server_username': value    => $vcenter_user;
    'glance_store/vmware_server_password': value    => $vcenter_password;
    'glance_store/vmware_datastore_name': value     => $vcenter_datastore;
    'glance_store/vmware_store_image_dir': value    => $vcenter_image_dir;
    'glance_store/vmware_task_poll_interval': value => $vcenter_task_poll_interval;
    'glance_store/vmware_api_retry_count': value    => $vcenter_api_retry_count;
    'glance_store/vmware_datacenter_path': value    => $vcenter_datacenter;
  }

  if $glare_enabled {
    glance_glare_config {
      'glance_store/vmware_api_insecure': value       => $vcenter_api_insecure;
      'glance_store/vmware_ca_file': value            => $vcenter_ca_file;
      'glance_store/vmware_server_host': value        => $vcenter_host;
      'glance_store/vmware_server_username': value    => $vcenter_user;
      'glance_store/vmware_server_password': value    => $vcenter_password;
      'glance_store/vmware_datastore_name': value     => $vcenter_datastore;
      'glance_store/vmware_store_image_dir': value    => $vcenter_image_dir;
      'glance_store/vmware_task_poll_interval': value => $vcenter_task_poll_interval;
      'glance_store/vmware_api_retry_count': value    => $vcenter_api_retry_count;
      'glance_store/vmware_datacenter_path': value    => $vcenter_datacenter;
    }
  }

  if !$multi_store {
    glance_api_config {  'glance_store/default_store': value => 'vsphere'; }
    if $glare_enabled {
      glance_glare_config {  'glance_store/default_store': value => 'vsphere'; }
    }
  }
}
