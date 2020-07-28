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
# [*cache_config*]
#   (optional) Allow configuration of glance-cache.conf configurations.
#
# [*image_import_config*]
#   (optional) Allow configuration of glance-image-import.conf configurations.
#
# DEPRECATED PARAMETERS
#
# [*registry_config*]
#   (optional) Allow configuration of glance-registry.conf configurations.
#
# [*registry_paste_ini_config*]
#   (optional) Allow configuration of glance-registry-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class glance::config (
  $api_config                 = {},
  $api_paste_ini_config       = {},
  $cache_config               = {},
  $image_import_config        = {},
  # DEPRECATED PARAMETERS
  $registry_config            = undef,
  $registry_paste_ini_config  = undef,
) {

  include glance::deps

  if $registry_config != undef {
    warning('glance::config::registry_config is deprecated and has no effect')
  }

  if $registry_paste_ini_config != undef {
    warning('glance::config::registry_paste_ini_config is deprecated and has no effect')
  }

  validate_legacy(Hash, 'validate_hash', $api_config)
  validate_legacy(Hash, 'validate_hash', $api_paste_ini_config)
  validate_legacy(Hash, 'validate_hash', $cache_config)
  validate_legacy(Hash, 'validate_hash', $image_import_config)

  create_resources('glance_api_config', $api_config)
  create_resources('glance_api_paste_ini', $api_paste_ini_config)
  create_resources('glance_cache_config', $cache_config)
  create_resources('glance_image_import_config', $image_import_config)
}
