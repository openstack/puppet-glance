# == class: glance::backend::rbd
#
# configures the storage backend for glance
# as a rbd instance
#
# === parameters:
#
#  [*rbd_store_user*]
#    Optional. Default: $facts['os_service_default'].
#
#  [*rbd_store_pool*]
#    Optional. Default: $facts['os_service_default'].
#
#  [*rbd_store_ceph_conf*]
#    Optional. Default: $facts['os_service_default'].
#
#  [*rbd_store_chunk_size*]
#    Optional. Default: $facts['os_service_default'].
#
#  [*rbd_thin_provisioning*]
#    Optional. Boolean describing if thin provisioning is enabled or not
#    Defaults to $facts['os_service_default']
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
#    Optional. Timeout value (in seconds) used when connecting
#    to ceph cluster. If value <= 0, no timeout is set and
#    default librados value is used.
#    Default: $facts['os_service_default'].
#
#  [*multi_store*]
#    Optional. Boolean describing if multiple backends will be configured
#    Defaults to false
#
class glance::backend::rbd(
  $rbd_store_user         = $facts['os_service_default'],
  $rbd_store_ceph_conf    = $facts['os_service_default'],
  $rbd_store_pool         = $facts['os_service_default'],
  $rbd_store_chunk_size   = $facts['os_service_default'],
  $rbd_thin_provisioning  = $facts['os_service_default'],
  $manage_packages        = true,
  $package_ensure         = 'present',
  $rados_connect_timeout  = $facts['os_service_default'],
  $multi_store            = false,
) {

  include glance::deps
  include glance::params

  warning('glance::backend::rbd is deprecated. Use glance::backend::multistore::rbd instead.')

  validate_legacy(Boolean, 'validate_bool', $multi_store)

  glance::backend::multistore::rbd { 'glance_store':
    rbd_store_ceph_conf   => $rbd_store_ceph_conf,
    rbd_store_user        => $rbd_store_user,
    rbd_store_pool        => $rbd_store_pool,
    rbd_store_chunk_size  => $rbd_store_chunk_size,
    rbd_thin_provisioning => $rbd_thin_provisioning,
    rados_connect_timeout => $rados_connect_timeout,
    manage_packages       => $manage_packages,
    package_ensure        => $package_ensure,
    store_description     => undef,
  }

  if !$multi_store {
    glance_api_config { 'glance_store/default_store': value => 'rbd'; }
  }
}
