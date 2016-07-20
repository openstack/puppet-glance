File.expand_path('../../../../openstacklib/lib', File.dirname(__FILE__)).tap { |dir| $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir) }
Puppet::Type.newtype(:glance_image) do
  desc <<-EOT
    This allows manifests to declare an image to be
    stored in glance.

    glance_image { "Ubuntu 12.04 cloudimg amd64":
      ensure           => present,
      name             => "Ubuntu 12.04 cloudimg amd64"
      is_public        => yes,
      container_format => ovf,
      disk_format      => 'qcow2',
      source           => 'http://uec-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img'
      min_ram          => 1234,
      min_disk         => 1234,
      properties       => { 'img_key' => img_value }
    }

    Known problems / limitations:
      * All images are managed by the glance service.
        This means that since users are unable to manage their own images via this type,
        is_public is really of no use. You can probably hide images this way but that's all.
      * As glance image names do not have to be unique, you must ensure that your glance
        repository does not have any duplicate names prior to using this.
      * Ensure this is run on the same server as the glance-api service.

  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The image name'
    newvalues(/.*/)
  end

  newproperty(:id) do
    desc 'The unique id of the image'
    newvalues(/[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}/)
  end

  newparam(:location) do
    desc "The permanent location of the image. Optional"
    newvalues(/\S+/)
  end

  newproperty(:is_public) do
    desc "Whether the image is public or not. Default true"
    newvalues(/(y|Y)es/, /(n|N)o/, /(t|T)rue/, /(f|F)alse/, true, false)
    defaultto(true)
    munge do |v|
      if v =~ /^(y|Y)es$/
        :true
      elsif v =~ /^(n|N)o$/
        :false
      else
        v.to_s.downcase.to_sym
      end
    end
  end

  newproperty(:container_format) do
    desc "The format of the container"
    newvalues(:ami, :ari, :aki, :bare, :ovf)
  end

  newproperty(:disk_format) do
    desc "The format of the disk"
    newvalues(:ami, :ari, :aki, :vhd, :vmdk, :raw, :qcow2, :vdi, :iso)
  end

  newparam(:source) do
    desc "The source of the image to import from"
    newvalues(/\S+/)
  end

  newproperty(:min_ram) do
    desc "The minimal ram size"
    newvalues(/\d+/)
  end

  newproperty(:min_disk) do
    desc "The minimal disk size"
    newvalues(/\d+/)
  end

  newproperty(:properties) do
    desc "The set of image properties"

    munge do |value|
      return value if value.is_a? Hash

      # wrap property value in commas
      value.gsub!(/=(\w+)/, '=\'\1\'')
      Hash[value.scan(/(\S+)='([^']*)'/)]
    end

    validate do |value|
      return true if value.is_a? Hash

      value.split(',').each do |property|
        raise ArgumentError, "Key/value pairs should be separated by an =" unless property.include?('=')
      end
    end
  end

  # Require the Glance service to be running
  autorequire(:service) do
    ['glance-api', 'glance-registry']
  end

end
