require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/glance')
require 'tempfile'
require 'net/http'

Puppet::Type.type(:glance_image).provide(
  :openstack,
  :parent => Puppet::Provider::Glance
) do
  desc <<-EOT
    Provider to manage glance_image type.
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  # TODO(flaper87): v2 is now the default. Force the use of v2,
  # to avoid supporting both versions and other edge cases.
  ENV['OS_IMAGE_API_VERSION'] = '2'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    temp_file = false
    if @resource[:source]
      if @resource[:proxy]
        proxy_uri = URI(@resource[:proxy])
        proxy_host = proxy_uri.host
        proxy_port = proxy_uri.port
      else
        proxy_host = nil
        proxy_port = nil
      end

      # copy_from cannot handle file://
      if @resource[:source] =~ /^\// # local file
        location = "--file=#{@resource[:source]}"
      else
        temp_file = Tempfile.new('puppet-glance-image')

        uri = URI(@resource[:source])
        Net::HTTP.start(uri.host, uri.port, proxy_host, proxy_port,
                        :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          http.request request do |response|
            open temp_file.path, 'w' do |io|
              response.read_body do |segment|
                io.write(segment)
              end
            end
          end
        end

        location = "--file=#{temp_file.path}"
      end

    # location cannot handle file://
    # location does not import, so no sense in doing anything more than this
    elsif @resource[:location]
      location = "--location=#{@resource[:location]}"
    else
      raise(Puppet::Error, "Must specify either source or location")
    end
    opts = [@resource[:name]]

    opts << (@resource[:is_public] == :true ? '--public' : '--private')
    opts << "--container-format=#{@resource[:container_format]}"
    opts << "--disk-format=#{@resource[:disk_format]}"
    opts << "--min-disk=#{@resource[:min_disk]}" if @resource[:min_disk]
    opts << "--min-ram=#{@resource[:min_ram]}" if @resource[:min_ram]
    opts << "--id=#{@resource[:id]}" if @resource[:id]
    opts << props_to_s(@resource[:properties]) if @resource[:properties]
    opts << "--tag=#{@resource[:image_tag]}" if @resource[:image_tag]
    opts << location

    begin
      @property_hash = self.class.request('image', 'create', opts)
      @property_hash[:ensure] = :present
    ensure
      if temp_file
        temp_file.close(true)
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('image', 'delete', @resource[:name])
    @property_hash.clear
  end

  mk_resource_methods

  def is_public=(value)
    @property_flush[:is_public] = value
  end

  def is_public
    bool_to_sym(@property_hash[:is_public])
  end

  def disk_format=(value)
    @property_flush[:disk_format] = value
  end

  def container_format=(value)
    @property_flush[:container_format] = value
  end

  def min_ram=(value)
    @property_flush[:min_ram] = value
  end

  def min_disk=(value)
    @property_flush[:min_disk] = value
  end

  def properties=(value)
    @property_flush[:properties] = value
  end

  def image_tag=(value)
    @property_flush[:image_tag] = value
  end

  def id=(id)
    fail('id for existing images can not be modified')
  end

  def self.instances
    list = request('image', 'list', '--long')
    list.collect do |image|
      attrs = request('image', 'show', image[:id])
      properties = parsestring(attrs[:properties]) rescue nil
      new(
        :ensure           => :present,
        :name             => attrs[:name],
        :is_public        => attrs[:visibility].downcase.chomp == 'public'? true : false,
        :container_format => attrs[:container_format],
        :id               => attrs[:id],
        :disk_format      => attrs[:disk_format],
        :min_disk         => attrs[:min_disk],
        :min_ram          => attrs[:min_ram],
        :properties       => exclude_owner_specified_props(exclude_readonly_props(properties)),
        :image_tag        => attrs[:image_tag]
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
    if @property_flush
      opts = [@resource[:name]]

      (opts << '--public') if @property_flush[:is_public] == :true
      (opts << '--private') if @property_flush[:is_public] == :false
      (opts << "--container-format=#{@property_flush[:container_format]}") if @property_flush[:container_format]
      (opts << "--disk-format=#{@property_flush[:disk_format]}") if @property_flush[:disk_format]
      (opts << "--min-ram=#{@property_flush[:min_ram]}") if @property_flush[:min_ram]
      (opts << "--min-disk=#{@property_flush[:min_disk]}") if @property_flush[:min_disk]
      (opts << props_to_s(@property_flush[:properties])) if @property_flush[:properties]
      (opts << "--tag=#{@property_flush[:image_tag]}") if @property_flush[:image_tag]

      self.class.request('image', 'set', opts)
      @property_flush.clear
    end
  end

  private

  def self.exclude_readonly_props(props)
    if props == nil
      return nil
    end
    hidden = ['os_hash_algo', 'os_hash_value', 'os_hidden', 'self']
    rv = props.select { |k, v| not hidden.include?(k) }
    return rv
  end

  def self.exclude_owner_specified_props(props)
    if props == nil
      return nil
    end
    rv = props.select { |k, v| not k.start_with?('owner_specified.') }
    return rv
  end

  def props_to_s(props)
    hidden = ['os_hash_algo', 'os_hash_value', 'os_hidden']
    props.flat_map{ |k, v|
      ['--property', "#{k}=#{v}"] unless hidden.include?(k)
    }.compact
  end

  def self.string2hash(input)
    return Hash[input.scan(/(\S+)='([^']*)'/)]
  end

  def self.pythondict2hash(input)
    return JSON.parse(input.gsub(/u'(\w*)'/, '"\1"').gsub(/'/, '"').gsub(/False/,'false').gsub(/True/,'true'))
  end

  def self.parsestring(input)
    if input[0] == '{'
      # 4.0.0+ output, python dict
      return self.pythondict2hash(input)
    else
      # Pre-4.0.0 output, key=value
      return self.string2hash(input)
    end
  end
end
