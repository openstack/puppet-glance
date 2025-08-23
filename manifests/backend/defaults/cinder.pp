# == Class: glance::backend::defaults::cinder
#
# Configure common defaults for all cinder backends
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
#   Defaults to $facts['os_service_default'].
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
class glance::backend::defaults::cinder (
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
  $cinder_os_region_name            = $facts['os_service_default'],
  $cinder_volume_type               = $facts['os_service_default'],
  $cinder_enforce_multipath         = $facts['os_service_default'],
  $cinder_use_multipath             = $facts['os_service_default'],
  $cinder_mount_point_base          = $facts['os_service_default'],
  $cinder_do_extend_attached        = $facts['os_service_default'],
) {
  include glance::deps

  glance_api_config {
    'backend_defaults/cinder_api_insecure':              value => $cinder_api_insecure;
    'backend_defaults/cinder_catalog_info':              value => $cinder_catalog_info;
    'backend_defaults/cinder_http_retries':              value => $cinder_http_retries;
    'backend_defaults/cinder_endpoint_template':         value => $cinder_endpoint_template;
    'backend_defaults/cinder_ca_certificates_file':      value => $cinder_ca_certificates_file;
    'backend_defaults/cinder_store_auth_address':        value => $cinder_store_auth_address;
    'backend_defaults/cinder_store_project_name':        value => $cinder_store_project_name;
    'backend_defaults/cinder_store_user_name':           value => $cinder_store_user_name;
    'backend_defaults/cinder_store_password':            value => $cinder_store_password, secret => true;
    'backend_defaults/cinder_store_user_domain_name':    value => $cinder_store_user_domain_name;
    'backend_defaults/cinder_store_project_domain_name': value => $cinder_store_project_domain_name;
    'backend_defaults/cinder_os_region_name':            value => $cinder_os_region_name;
    'backend_defaults/cinder_volume_type':               value => $cinder_volume_type;
    'backend_defaults/cinder_enforce_multipath':         value => $cinder_enforce_multipath;
    'backend_defaults/cinder_use_multipath':             value => $cinder_use_multipath;
    'backend_defaults/cinder_mount_point_base':          value => $cinder_mount_point_base;
    'backend_defaults/cinder_do_extend_attached':        value => $cinder_do_extend_attached;
  }

  glance_cache_config {
    'backend_defaults/cinder_api_insecure':              value => $cinder_api_insecure;
    'backend_defaults/cinder_catalog_info':              value => $cinder_catalog_info;
    'backend_defaults/cinder_http_retries':              value => $cinder_http_retries;
    'backend_defaults/cinder_endpoint_template':         value => $cinder_endpoint_template;
    'backend_defaults/cinder_ca_certificates_file':      value => $cinder_ca_certificates_file;
    'backend_defaults/cinder_store_auth_address':        value => $cinder_store_auth_address;
    'backend_defaults/cinder_store_project_name':        value => $cinder_store_project_name;
    'backend_defaults/cinder_store_user_name':           value => $cinder_store_user_name;
    'backend_defaults/cinder_store_password':            value => $cinder_store_password, secret => true;
    'backend_defaults/cinder_store_project_domain_name': value => $cinder_store_project_domain_name;
    'backend_defaults/cinder_store_user_domain_name':    value => $cinder_store_user_domain_name;
    'backend_defaults/cinder_os_region_name':            value => $cinder_os_region_name;
    'backend_defaults/cinder_volume_type':               value => $cinder_volume_type;
    'backend_defaults/cinder_enforce_multipath':         value => $cinder_enforce_multipath;
    'backend_defaults/cinder_use_multipath':             value => $cinder_use_multipath;
    'backend_defaults/cinder_mount_point_base':          value => $cinder_mount_point_base;
    'backend_defaults/cinder_do_extend_attached':        value => $cinder_do_extend_attached;
  }
}
