## 8.0.0 and beyond

From 8.0.0 release and beyond, release notes are published on
[docs.openstack.org](http://docs.openstack.org/releasenotes/puppet-glance/).

##2015-11-25 - 7.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Liberty.

####Backwards-incompatible changes
- remove deprecated mysql_module
- change section name for AMQP qpid parameters
- change section name for AMQP rabbit parameters

####Features
- add support for RabbitMQ connection heartbeat
- add tag to package and service resources
- add glance::db::sync
- add an ability to manage use_stderr parameter
- reflect provider change in puppet-openstacklib
- put all the logging related parameters to the logging class
- allow customization of db sync command line
- add S3 backend configuration for glance
- add rados_connect_timeout parameter in glance config
- add ability to specify number of workers for glance-registry service
- use OpenstackClient for glance_image auth

####Bugfixes
- rely on autorequire for config resource ordering
- make sure Facter is only executed on agent
- file backend: do not inherit from glance::api
- glance_image: hardcode os-image-api-version to 1
- make sure Glance_image is executed after Keystone_endpoint
- solve duplicate declaration issue for python-openstackclient
- append openstacklib/lib to load path for type

####Maintenance
- fix rspec 3.x syntax
- initial msync run for all Puppet OpenStack modules
- try to use zuul-cloner to prepare fixtures
- remove class_parameter_defaults puppet-lint check
- acceptance: use common bits from puppet-openstack-integration
- fix unit tests against Puppet 4.3.0
- require at least 4.2.0 of stdlib

##2015-10-10 - 6.1.0
###Summary

This is a feature and maintenance release in the Kilo series.

####Features
- Add the swift_store_region parameter to glance::backend::swift

####Maintenance
- acceptance: checkout stable/kilo puppet modules


##2015-07-08 - 6.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Kilo.

####Backwards-incompatible changes
- Move rabbit/kombu settings to oslo_messaging_rabbit section.
- Remove sql_connection and sql_idle_timeout deprecated parameters.
- api: change default pipeline.
- Separate api and registry packages for Red Hat.
- python-ceph no longer exists in el7, use python-rbd.

####Features
- Puppet 4.x support.
- Refactorise Keystone resources management.
- Migrate postgresql backend to use openstacklib::db::postgresql.
- Add support for identity_uri.
- Service Validation for Glance-API.
- Create a sync_db boolean for Glance.
- make service description configurable.

####Bugfixes
- Fix API/Registry ensure for Ubuntu.

####Maintenance
- Acceptance tests with Beaker.
- Fix spec tests for RSpec 3.x and Puppet 4.x.

##2015-06-17 - 5.1.0
###Summary

This is a feature and bugfix release in the Juno series.

####Features
- Add service validation for Glance-API.
- Switch to TLSv1.
- Makes kombu_ssl_* parameters optional when rabbit_use_ssl => true.
- Allow overriding package ensure for glance-registry.
- Add openstack tag to glance packages.
- Create a sync_db boolean for Glance.
- Command parameter to sync the correct Database.
- Add $notification_driver parameter to notify::rabbitmq.

####Bugfixes
- Move rbd related options into glance_store section.
- Change default MySQL collate to utf8_general_ci.
- Correctly munge glance_image is_public property.
- Fix catalog compilation when not configuring endpoint.
- Fix is_public munge.

####Maintenance
- spec: pin rspec-puppet to 1.0.1.
- Pin puppetlabs-concat to 1.2.1 in fixtures.
- Update .gitreview file for project rename.

##2014-11-24 - 5.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Juno.

####Backwards-incompatible changes
- Bump stdlib dependency to >=4.0.0.
- Migrate the mysql backend to use openstacklib::db::mysql, adding dependency
  on puppet-openstacklib.

####Features
- Add ceilometer::policy to control policy.json.
- Add parameter os_region_name to glance::api.
- Add support for vSphere datastore backend.
- Update the calls to the glance command-line utility.
- Add parameter swift_store_large_object_size to glance::backend::swift.
- Add parameter command_options to glance::cache::cleaner and glance::cache::pruner.
- Add parameter package_ensure to glance::backend::rbd.
- Add parameter manage_service to various classes.
- Add parameters to control whether to configure users.
- Add parameter registery_client_protocol to glance::api.

####Bugfixes
- Fix bug in glance_image type.
- Fix ssl parameter requirements for kombu and rabbit.

##2014-10-16 - 4.2.0
###Summary

This is a feature release in the Icehouse series.

####Features

- Add ability to hide secret type parameters from logs.

##2014-06-19 - 4.1.0
###Summary

This is a feature and bugfix release in the Icehouse series.

####Features
- Add multiple rabbit hosts support.
- Add image_cache_dir parameter.
- Deprecate old SQL parameters.

####Bugfixes
- Fix the Glance add_image parser for new client.
- Fix values in get_glance_image_attrs.
- Fix 'could not find user glance' bug.

####Maintenance
- Pin major gems.

##2014-05-01 - 4.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Icehouse.

####Backwards-incompatible changes
- Remove deprecated notifier_stratgy parameter.

####Features
- Add glance::config to handle additional custom options.
- Add known_stores option for glance::api.
- Add copy-on-write cloning of images to volumes.
- Add support for puppetlabs-mysql 2.2 and greater.
- Add support for python-glanceclient v2 API update.
- Deprecate show_image_direct_url in glance::rbd.

##2014-03-26 - 3.1.0
###Summary

This is a feature and bugfix release in the Havana series.

####Features
- Add availability to configure show_image_direct_url.
- Add support for https authentication endpoints.
- Enable ssl configuration for glance-registry.
- Explicitly set default notifier strategy.

####Bugfixes
- Remove Keystone client warnings.

##2014-01-09 - 3.0.0
###Summary

This is a major release for OpenStack Havana but contains no API-breaking
changes.

####Features
- Add Cinder backend to image storage.

####Bugfixes
- Fix bug to ensure keystone endpoint is set before service starts.
- Fix qpid_hostname bug.

##2013-10-07 - 2.2.0
###Summary

This is a feature and bugfix release in the Grizzly series.

####Features
- Add syslog support.
- Add support for iso disk format.

####Bugfixes
- Fix bug to allow support for rdb options in glance-api.conf.
- Fix bug for rabbitmq options in notify::rabbitmq.
- Remove non-implemented glance::scrubber class.

##2013-08-07 - 2.1.0
###Summary

This is a feature and bugfix release in the Grizzly series.

####Features

- Add glance-cache-cleaner and glance-cache-pruner.
- Add ceph/rdb support.
- Add retry for glance provider to account for service startup time.
- Add support for both file and swift backends.

####Bugfixes
- Fix allowed_hosts/database access bug.
- Fix glance_image type example.
- Remove unnecessary mysql::server dependency.
- Remove --silent-upload option.
- Remove glance-manage version_control.

####Maintenance
- Pin rabbit and mysql module versions.

##2013-06-24 - 2.0.0
###Summary

Initial release on Stackforge.

####Features
- Add postgresql support.
