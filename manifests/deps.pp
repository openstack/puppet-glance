# == Class: glance::deps
#
#  glance anchors and dependency management
#
class glance::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'glance::install::begin': }
  -> Package<| tag == 'glance-package'|>
  ~> anchor { 'glance::install::end': }
  -> anchor { 'glance::config::begin': }
  -> File<| tag == 'glance-config-file' |>
  ~> anchor { 'glance::config::end': }
  -> anchor { 'glance::db::begin': }
  -> anchor { 'glance::db::end': }
  ~> anchor { 'glance::dbsync::begin': }
  -> anchor { 'glance::dbsync::end': }
  ~> anchor { 'glance::service::begin': }
  ~> Service<| tag == 'glance-service' |>
  ~> anchor { 'glance::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['glance::dbsync::begin']

  # Ensure files are modified in the config block
  Anchor['glance::config::begin']
  -> File_line<| tag == 'glance-file-line' |>
  ~> Anchor['glance::config::end']

  # Ensure all files are in place before modifying them
  File<| tag == 'glance-config-file' |> -> File_line<| tag == 'glance-file-line' |>

  # All other inifile providers need to be processed in the config block
  Anchor['glance::config::begin'] -> Glance_api_config<||> ~> Anchor['glance::config::end']
  Anchor['glance::config::begin'] -> Glance_api_paste_ini<||> ~> Anchor['glance::config::end']
  Anchor['glance::config::begin'] -> Glance_cache_config<||> ~> Anchor['glance::config::end']
  Anchor['glance::config::begin'] -> Glance_registry_config<||> ~> Anchor['glance::config::end']
  Anchor['glance::config::begin'] -> Glance_registry_paste_ini<||> ~> Anchor['glance::config::end']
  Anchor['glance::config::begin'] -> Glance_swift_config<||> ~> Anchor['glance::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the glance-package tag and the glance-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the glance::install::end anchor.  The line between glance-support-package and
  # glance-package should be whether or not glance services would need to be
  # restarted if the package state was changed.
  Anchor['glance::install::begin']
  -> Package<| tag == 'glance-support-package'|>
  -> Anchor['glance::install::end']

  Anchor['glance::service::end'] -> Glance_image<||>

  # Installation or config changes will always restart services.
  Anchor['glance::install::end'] ~> Anchor['glance::service::begin']
  Anchor['glance::config::end']  ~> Anchor['glance::service::begin']
}
