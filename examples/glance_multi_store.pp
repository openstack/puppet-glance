# Example: Declaring multiple backend stores
#
# To declare multiple glance::backend::* classes, each declaration must include
# the parameter multi_store set to true. This prevents each individual backend from
# setting itself as the default store as soon as it is declared. Rather, the
# default store can be chosen by the user when declaring glance::api (if no
# default_store is set at that point, then the first store in the list 'stores'
# provided will be made the default).

class { '::glance::backend::file':
  multi_store => true,
}

class { '::glance::backend::swift':
  swift_store_user => 'demo',
  swift_store_key  => 'secrete',
  multi_store      => true,
}

class { '::glance::api':
  keystone_password => 'a_big_secret',
  stores            => ['file', 'swift'],
  default_store     => 'swift',
  multi_store       => true,
}
