# == class: glance::backend::rbd
#
# configures the storage backend for glance
# as a rbd instance
#
# === parameters:
#
#  [*rbd_store_user*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_pool*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_ceph_conf*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_chunk_size*]
#    Optional. Default: $::os_service_default.
#
#  [*manage_packages*]
#    Optional. Whether we should manage the packages.
#    Defaults to true,
#
#  [*package_ensure*]
#    Optional. Desired ensure state of packages.
#    accepts latest or specific versions.
#    Defaults to present.
#
#  [*rados_connect_timeout*]
#    Optinal. Timeout value (in seconds) used when connecting
#    to ceph cluster. If value <= 0, no timeout is set and
#    default librados value is used.
#    Default: $::os_service_default.
#
#  [*multi_store*]
#    Optional. Boolean describing if multiple backends will be configured
#    Defaults to false
#
class glance::backend::rbd(
  $rbd_store_user         = $::os_service_default,
  $rbd_store_ceph_conf    = $::os_service_default,
  $rbd_store_pool         = $::os_service_default,
  $rbd_store_chunk_size   = $::os_service_default,
  $manage_packages        = true,
  $package_ensure         = 'present',
  $rados_connect_timeout  = $::os_service_default,
  $multi_store            = false,
) {

  include ::glance::deps
  include ::glance::params

  glance_api_config {
    'glance_store/rbd_store_ceph_conf':    value => $rbd_store_ceph_conf;
    'glance_store/rbd_store_user':         value => $rbd_store_user;
    'glance_store/rbd_store_pool':         value => $rbd_store_pool;
    'glance_store/rbd_store_chunk_size':   value => $rbd_store_chunk_size;
    'glance_store/rados_connect_timeout':  value => $rados_connect_timeout;
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'rbd'; }
  }

  if $manage_packages {
    package { 'python-ceph':
      ensure => $package_ensure,
      name   => $::glance::params::pyceph_package_name,
      tag    => 'glance-support-package',
    }
  }

}
