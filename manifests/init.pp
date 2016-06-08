# == class: glance
#
# base glance config.
#
# === parameters:
#
#  [*package_ensure*]
#    (Optional) Ensure state for package. On Ubuntu this setting
#    is ignored since Ubuntu has separate API and registry packages.
#    Defaults to 'present'
#
class glance(
  $package_ensure = 'present'
) {

  include ::glance::deps
  include ::glance::params

  if ( $glance::params::api_package_name == $glance::params::registry_package_name ) {
    package { $::glance::params::api_package_name :
      ensure => $package_ensure,
      name   => $::glance::params::api_package_name,
      tag    => ['openstack', 'glance-package'],
    }
  }

  include '::openstacklib::openstackclient'
}
