# == Class: glance::db::postgresql
#
# Class that configures postgresql for glance
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'glance'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'glance'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class glance::db::postgresql(
  $password,
  $dbname     = 'glance',
  $user       = 'glance',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include glance::deps

  openstacklib::db::postgresql { 'glance':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['glance::db::begin']
  ~> Class['glance::db::postgresql']
  ~> Anchor['glance::db::end']

}
