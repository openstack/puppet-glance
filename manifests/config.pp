# == Class: glance::config
#
# This class is used to manage arbitrary glance configurations.
#
# example xxx_config
#   (optional) Allow configuration of arbitrary glance configurations.
#   The value is an hash of glance_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   glance_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# === Parameters
#
# [*api_config*]
#   (optional) Allow configuration of glance-api.conf configurations.
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of glance-api-paste.ini configurations.
#
# [*cache_config*]
#   (optional) Allow configuration of glance-cache.conf configurations.
#
# [*image_import_config*]
#   (optional) Allow configuration of glance-image-import.conf configurations.
#
# [*rootwrap_config*]
#   (optional) Allow configuration of rootwrap.conf configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class glance::config (
  Hash $api_config           = {},
  Hash $api_paste_ini_config = {},
  Hash $cache_config         = {},
  Hash $image_import_config  = {},
  Hash $rootwrap_config      = {},
) {

  include glance::deps

  create_resources('glance_api_config', $api_config)
  create_resources('glance_api_paste_ini', $api_paste_ini_config)
  create_resources('glance_cache_config', $cache_config)
  create_resources('glance_image_import_config', $image_import_config)
  create_resources('glance_rootwrap_config', $rootwrap_config)
}
