# == class: glance
#
# base glance config.
#
class glance {

  include ::glance::params

  file { '/etc/glance/':
    ensure => directory,
    owner  => 'glance',
    group  => 'root',
    mode   => '0770',
  }
}
