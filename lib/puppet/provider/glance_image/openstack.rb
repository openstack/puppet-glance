require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/glance')

Puppet::Type.type(:glance_image).provide(
  :openstack,
  :parent => Puppet::Provider::Glance
) do
  desc <<-EOT
    Provider to manage glance_image type.
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV2_0.new

  # glanceclient support `image create` (in v2 API) but not openstackclient
  # openstackclient now uses image v2 API by default.
  # in the meantime it's implemented in openstackclient, hardcode version
  # see https://bugs.launchpad.net/python-openstackclient/+bug/1405562
  ENV['OS_IMAGE_API_VERSION'] = '1'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    if resource[:source]
      # copy_from cannot handle file://
      if resource[:source] =~ /^\// # local file
        location = "--file=#{resource[:source]}"
      else
        location = "--copy-from=#{resource[:source]}"
      end
    # location cannot handle file://
    # location does not import, so no sense in doing anything more than this
    elsif resource[:location]
      location = "--location=#{resource[:location]}"
    else
      raise(Puppet::Error, "Must specify either source or location")
    end
    properties = [resource[:name]]
    if resource[:is_public] == :true
      properties << "--public"
    else
      # This is the default, but it's nice to be verbose
      properties << "--private"
    end
    properties << "--container-format=#{resource[:container_format]}"
    properties << "--disk-format=#{resource[:disk_format]}"
    properties << "--min-disk=#{resource[:min_disk]}" if resource[:min_disk]
    properties << "--min-ram=#{resource[:min_ram]}" if resource[:min_ram]
    properties << location
    @property_hash = self.class.request('image', 'create', properties)
    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('image', 'delete', resource[:name])
    @property_hash.clear
  end

  def is_public=(value)
    @property_flush[:is_public] = value
  end

  def is_public
    bool_to_sym(@property_hash[:is_public])
  end

  def disk_format=(value)
    @property_flush[:disk_format] = value
  end

  def disk_format
    @property_hash[:disk_format]
  end

  def container_format=(value)
    @property_flush[:container_format] = value
  end

  def container_format
    @property_hash[:container_format]
  end

  def min_ram=(value)
    @property_flush[:min_ram] = value
  end

  def min_disk=(value)
    @property_flush[:min_disk] = value
  end

  def id=(id)
    fail('id is read only')
  end

  def id
    @property_hash[:id]
  end

  def self.instances
    list = request('image', 'list', '--long')
    list.collect do |image|
      attrs = request('image', 'show', image[:id])
      new(
        :ensure           => :present,
        :name             => attrs[:name],
        :is_public        => attrs[:is_public].downcase.chomp == 'true'? true : false,
        :container_format => attrs[:container_format],
        :id               => attrs[:id],
        :disk_format      => attrs[:disk_format],
        :min_disk         => attrs['min_disk'],
        :min_ram          => attrs['min_ram']
      )
    end
  end

  def self.prefetch(resources)
    images = instances
    resources.keys.each do |name|
      if provider = images.find{ |image| image.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    properties = [resource[:name]]
    if @property_flush
      (properties << '--public') if @property_flush[:is_public] == :true
      (properties << '--private') if @property_flush[:is_public] == :false
      (properties << "--container-format=#{@property_flush[:container_format]}") if @property_flush[:container_format]
      (properties << "--disk-format=#{@property_flush[:disk_format]}") if @property_flush[:disk_format]
      (properties << "--min-ram=#{@property_flush[:min_ram]}") if @property_flush[:min_ram]
      (properties << "--min-disk=#{@property_flush[:min_disk]}") if @property_flush[:min_disk]
      self.class.request('image', 'set', properties)
      @property_flush.clear
    end
  end

end
