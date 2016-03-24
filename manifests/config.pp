# == Class: glance::config
#
# This class is used to manage arbitrary glance configurations.
#
# === Parameters
#
# [*xxx_config*]
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
# [*api_config*]
#   (optional) Allow configuration of glance-api.conf configurations.
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of glance-api-paste.ini configurations.
#
# [*registry_config*]
#   (optional) Allow configuration of glance-registry.conf configurations.
#
# [*registry_paste_ini_config*]
#   (optional) Allow configuration of glance-registry-paste.ini configurations.
#
# [*glare_config*]
#   (optional) Allow configuration of glance-glare.conf configurations.
#
# [*glare_paste_ini_config*]
#   (optional) Allow configuration of glance-glare-paste.ini configurations.
#
# [*cache_config*]
#   (optional) Allow configuration of glance-cache.conf configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class glance::config (
  $api_config                 = {},
  $api_paste_ini_config       = {},
  $registry_config            = {},
  $registry_paste_ini_config  = {},
  $glare_config               = {},
  $glare_paste_ini_config     = {},
  $cache_config               = {},
) {
  validate_hash($api_config)
  validate_hash($api_paste_ini_config)
  validate_hash($registry_config)
  validate_hash($registry_paste_ini_config)
  validate_hash($cache_config)
  validate_hash($glare_config)
  validate_hash($glare_paste_ini_config)

  create_resources('glance_api_config', $api_config)
  create_resources('glance_api_paste_ini', $api_paste_ini_config)
  create_resources('glance_registry_config', $registry_config)
  create_resources('glance_registry_paste_ini', $registry_paste_ini_config)
  create_resources('glance_cache_config', $cache_config)
  create_resources('glance_glare_config', $glare_config)
  create_resources('glance_glare_paste_ini', $glare_paste_ini_config)
}
