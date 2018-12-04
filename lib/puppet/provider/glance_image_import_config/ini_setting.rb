Puppet::Type.type(:glance_image_import_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/glance/glance-image-import.conf'
  end

end
