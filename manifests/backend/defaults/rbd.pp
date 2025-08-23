# == Class: glance::backend::defaults::rbd
#
# Configure common defaults for all rbd backends
#
# === Parameters:
#
# [*rbd_store_user*]
#   Optional. Default: $facts['os_service_default'].
#
# [*rbd_store_pool*]
#   Optional. Default: $facts['os_service_default'].
#
# [*rbd_store_ceph_conf*]
#   Optional. Default: $facts['os_service_default'].
#
# [*rbd_store_chunk_size*]
#   Optional. Default: $facts['os_service_default'].
#
# [*rbd_thin_provisioning*]
#   Optional. Boolean describing if thin provisioning is enabled or not
#   Defaults to $facts['os_service_default']
#
# [*rados_connect_timeout*]
#   Optional. Timeout value (in seconds) used when connecting to ceph cluster.
#   Default: $facts['os_service_default'].
#
class glance::backend::defaults::rbd (
  $rbd_store_user        = $facts['os_service_default'],
  $rbd_store_ceph_conf   = $facts['os_service_default'],
  $rbd_store_pool        = $facts['os_service_default'],
  $rbd_store_chunk_size  = $facts['os_service_default'],
  $rbd_thin_provisioning = $facts['os_service_default'],
  $rados_connect_timeout = $facts['os_service_default'],
) {
  include glance::deps

  glance_api_config {
    'backend_defaults/rbd_store_user':        value => $rbd_store_user;
    'backend_defaults/rbd_store_ceph_conf':   value => $rbd_store_ceph_conf;
    'backend_defaults/rbd_store_pool':        value => $rbd_store_pool;
    'backend_defaults/rbd_store_chunk_size':  value => $rbd_store_chunk_size;
    'backend_defaults/rbd_thin_provisioning': value => $rbd_thin_provisioning;
    'backend_defaults/rados_connect_timeout': value => $rados_connect_timeout;
  }

  glance_cache_config {
    'backend_defaults/rbd_store_user':        value => $rbd_store_user;
    'backend_defaults/rbd_store_ceph_conf':   value => $rbd_store_ceph_conf;
    'backend_defaults/rbd_store_pool':        value => $rbd_store_pool;
    'backend_defaults/rbd_store_chunk_size':  value => $rbd_store_chunk_size;
    'backend_defaults/rbd_thin_provisioning': value => $rbd_thin_provisioning;
    'backend_defaults/rados_connect_timeout': value => $rados_connect_timeout;
  }
}
