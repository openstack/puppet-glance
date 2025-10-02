Puppet::Type.newtype(:glance_image) do
  desc <<-EOT
    This allows manifests to declare an image to be
    stored in glance.

    glance_image { "Ubuntu 12.04 cloudimg amd64":
      ensure           => present,
      name             => "Ubuntu 12.04 cloudimg amd64",
      is_public        => yes,
      container_format => 'ovf',
      disk_format      => 'qcow2',
      source           => 'http://uec-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img',
      proxy            => 'http://127.0.0.1:8080',
      min_ram          => 1234,
      min_disk         => 1234,
      properties       => { 'img_key' => img_value },
      image_tag        => 'amphora',
    }

    Known problems / limitations:
      * All images are managed by the admin user unless the credentail input is overridden.
        This means that since users are unable to manage their own images via this type,
        is_public is really of no use. You can probably hide images this way but that's all.
      * As glance image names do not have to be unique, you must ensure that your glance
        repository does not have any duplicate names prior to using this.

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
    newvalues(:ami, :ari, :aki, :bare, :ovf, :ova, :docker, :compressed)
  end

  newproperty(:disk_format) do
    desc "The format of the disk"
    newvalues(:ami, :ari, :aki, :vhd, :vhdx, :vmdk, :raw, :qcow2, :vdi, :iso, :ploop)
  end

  newparam(:source) do
    desc "The source of the image to import from"
    newvalues(/\S+/)
  end

  newparam(:proxy) do
    desc "The proxy server to use if source should be downloaded"
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

  newparam(:project_name) do
    desc 'The name of the project which will own the image.'
  end

  newproperty(:project_id) do
    desc 'A uuid identifying the project which will own the image.'
  end

  newproperty(:properties) do
    desc "The set of image properties"

    validate do |value|
      if value.is_a?(Hash)
        return true
      else
        raise ArgumentError, "Invalid properties #{value}. Requires a Hash, not a #{value.class}"
      end
    end
  end

  newproperty(:image_tag) do
    desc "The image tag"
    newvalues(/\S+/)
  end

  # Require the Glance service to be running
  autorequire(:anchor) do
    ['glance::service::end']
  end

  validate do
    if self[:ensure] != :present
      return
    end
    if self[:project_id] && self[:project_name]
      raise(Puppet::Error, <<-EOT
Please provide a value for only one of project_name and project_id
EOT
            )
    end
  end

end
