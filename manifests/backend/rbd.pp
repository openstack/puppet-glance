#
# configures the storage backend for glance
# as a rbd instance
#
#  $rbd_store_user - Optional.
#
#  $rbd_store_pool - Optional. Default:'images',
#

class glance::backend::rbd(
  $rbd_store_user = undef,
  $rbd_store_pool = 'images',
) {
  include glance::params

  glance_api_config {
    'DEFAULT/default_store':     value => 'rbd';
    'DEFAULT/rbd_store_user':    value => $rbd_store_user;
    'DEFAULT/rbd_store_pool':    value => $rbd_store_pool;
  }

  package { 'python-ceph':
    ensure => 'present',
    name   => $::glance::params::pyceph_package_name,
  }

}
