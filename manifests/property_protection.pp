# == Class: glance::property_protection
#
# Configure property protection
#
# === Parameters
#
# [*property_protection_rule_format*]
#  (Optional) Rule format for property protection.
#  Defaults to undef
#
# [*rules*]
#  (Optional) Property protection rules
#  Defaults to undef
#
# [*purge_config*]
#   (Optional) Whether to set only the specified config options
#   in the property protections config.
#   Defaults to false.
#
class glance::property_protection(
  Optional[Enum['roles', 'policies']] $property_protection_rule_format = undef,
  Hash[String[1], Hash] $rules                                         = {},
  Boolean $purge_config                                                = false,
) {

  include glance::deps
  include glance::params

  resources { 'glance_property_protections_config':
    purge => $purge_config,
  }

  case $property_protection_rule_format {
    'roles', 'policies': {
      glance_api_config {
        'DEFAULT/property_protection_file':        value => '/etc/glance/property-protections.conf';
        'DEFAULT/property_protection_rule_format': value => $property_protection_rule_format;
      }

      # NOTE(tkajinam): property-protections.conf is not installed by
      # the packages so create the file in advance.
      file { '/etc/glance/property-protections.conf':
        ensure  => 'file',
        owner   => 'root',
        group   => $glance::params::group,
        mode    => '0640',
        require => Anchor['glance::config::begin'],
        notify  => Anchor['glance::config::end'],
      }

      $rules.each |$key, $value| {
        $value_override = $value['value'] ? {
          undef   => {},
          default => {'value' => join(any2array($value['value']), ',')},
        }

        create_resources(
          'glance_property_protections_config',
          { $key =>  stdlib::merge($value, $value_override)}
        )
      }

      File['/etc/glance/property-protections.conf'] -> Glance_property_protections_config<||>
    }
    default: {
      glance_api_config {
        'DEFAULT/property_protection_file':        value => $facts['os_service_default'];
        'DEFAULT/property_protection_rule_format': value => $facts['os_service_default'];
      }

      file { '/etc/glance/property-protections.conf':
        ensure  => absent,
        require => Anchor['glance::config::begin'],
        notify  => Anchor['glance::config::end'],
      }
    }
  }
}
