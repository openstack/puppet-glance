Puppet::Type.type(:glance_registry_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/glance/glance-registry-paste.ini'
  end

end
