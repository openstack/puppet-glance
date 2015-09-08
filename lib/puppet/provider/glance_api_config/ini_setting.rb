Puppet::Type.type(:glance_api_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/glance/glance-api.conf'
  end

end
