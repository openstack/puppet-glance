# Example: Declaring a single backend store
#
# To declare only one glance::backend::* class, all you need to do is declare
# it without the multi_store parameter. This way, multi_store will default to false
# and the glance::backend::* class will automatically set itself as the default backend.
# After doing this, you must not declare glance::api with multi_store set to true,
# or it will attempt to override the default set by the backend class and result
# in an error.

class { '::glance::backend::swift':
  swift_store_user => 'demo',
  swift_store_key  => 'secrete',
}

class { '::glance::api':
  keystone_password => 'a_big_secret',
  stores            => ['swift'],
}
