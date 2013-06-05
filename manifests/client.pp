#
# Installs the glance python library.
#
# == parameters
#  * ensure - ensure state for pachage.
#
class glance::client (
  $ensure = 'present'
) {

  include glance::params

  package { 'python-glance':
    name   => $::glance::params::client_package_name,
    ensure => $ensure,
  }

}
