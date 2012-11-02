# PuppetLabs Glance module

This module provides a set of manifests that can be used to install and
configure glance.

It is currently targettting the folsom release of OpenStack.

Use the essex branch for essex support.

## Platforms

* Ubuntu 11.04 (Natty)
* Ubuntu 11.10 (Oneiric)
* Ubuntu 12.04 (Precise)

## configurations

Glance is configured with the following classes:


  #configures glance::api service

  class { 'glance::api':
    verbose           => $verbose,
    debug             => $verbose,
    auth_type         => 'keystone',
    auth_port         => '35357',
    auth_host         => $keystone_host,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $glance_user_password,
    sql_connection    => $sql_connection,
    enabled           => $enabled,
  }

  # configures the glance registry

  class { 'glance::registry':
    verbose           => $verbose,
    debug             => $verbose,
    auth_host         => $keystone_host,
    auth_port         => '35357',
    auth_type         => 'keystone',
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    keystone_password => $glance_user_password,
    sql_connection    => $sql_connection,
    enabled           => $enabled,
  }

  # Configure file storage backend

  class { 'glance::backend::file': }

  # Create the Glance db, this should be configured on your mysql server
  class { 'glance::db::mysql':
    user          => $glance_db_user,
    password      => $glance_db_password,
    dbname        => $glance_db_dbname,
    allowed_hosts => $allowed_hosts,
  }

  # configures glance endpoints in keystone
  # should be run on your keystone server
  class { 'glance::keystone::auth':
    password         => $glance_user_password,
    public_address   => $glance_public_real,
    admin_address    => $glance_admin_real,
    internal_address => $glance_internal_real,
    region           => $region,
  }

for full examples, see the examples directory.

in the module, puppetlabs-openstack, the following classes
configure parts of glance:

  - openstack::glance    # api, file backend, and registry
  - openstack::keystone  # sets up endpoints
  - openstack::db::mysql # sets up db config
