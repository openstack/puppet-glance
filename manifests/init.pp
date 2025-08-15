# == class: glance
#
# base glance config.
#
# === parameters:
#
#  [*package_ensure*]
#    (Optional) Ensure state for package. On Ubuntu this setting
#    is ignored since Ubuntu has packages per services
#    Defaults to 'present'
#
class glance(
  $package_ensure = 'present'
) {

  include glance::deps
  include glance::params

  if ( $glance::params::package_name != undef ) {
    package { 'glance' :
      ensure => $package_ensure,
      name   => $glance::params::package_name,
      tag    => ['openstack', 'glance-package'],
    }
  }

  include openstacklib::openstackclient
}
