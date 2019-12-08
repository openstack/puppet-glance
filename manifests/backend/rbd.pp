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

  include glance::deps
  include glance::params

  warning('glance::backend::rbd is deprecated. Use glance::backend::multistore::rbd instead.')

  glance::backend::multistore::rbd { 'glance_store':
    rbd_store_ceph_conf   => $rbd_store_ceph_conf,
    rbd_store_user        => $rbd_store_user,
    rbd_store_pool        => $rbd_store_pool,
    rbd_store_chunk_size  => $rbd_store_chunk_size,
    rados_connect_timeout => $rados_connect_timeout,
    manage_packages       => $manage_packages,
    package_ensure        => $package_ensure,
    store_description     => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'rbd'; }
  }
}
