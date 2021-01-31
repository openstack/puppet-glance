glance::backend::multistore::file { 'file1': }

glance::backend::multistore::swift { 'swift1':
  swift_store_user => 'demo',
  swift_store_key  => 'secrete',
}

class { 'glance::api':
  keystone_password => 'a_big_secret',
  enabled_backends  => ['swift1:swift', 'file1:file'],
  default_backend   => 'swift1',
}
