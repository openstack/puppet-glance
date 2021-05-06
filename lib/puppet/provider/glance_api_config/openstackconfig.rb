Puppet::Type.type(:glance_api_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/glance/glance-api.conf'
  end

end
