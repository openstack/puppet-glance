# Since there's only one Glance type for now,
# this probably could have all gone in the provider file.
# But maybe this is good long-term.
require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'
class Puppet::Provider::Glance < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

  def self.request(service, action, properties=nil)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError => error
      glance_request(service, action, error, properties)
    end
  end

  def self.glance_request(service, action, error, properties=nil)
    properties ||= []
    @credentials.username = glance_credentials['username']
    @credentials.password = glance_credentials['password']
    @credentials.project_name = glance_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    @credentials.user_domain_name = glance_credentials['user_domain_name']
    @credentials.project_domain_name = glance_credentials['project_domain_name']
    if glance_credentials['region_name']
      @credentials.region_name = glance_credentials['region_name']
    end
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.conf_filename
    '/etc/glance/glance-api.conf'
  end

  def self.glance_conf
    return @glance_conf if @glance_conf
    @glance_conf = Puppet::Util::IniConfig::File.new
    @glance_conf.read(conf_filename)
    @glance_conf
  end

  def self.glance_credentials
    @glance_credentials ||= get_glance_credentials
  end

  def self.get_glance_credentials
    #needed keys for authentication
    auth_keys = ['auth_url', 'project_name', 'username', 'password']
    conf = glance_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]

      if !conf['keystone_authtoken']['region_name'].nil?
        creds['region_name'] = conf['keystone_authtoken']['region_name'].strip
      end

      if !conf['keystone_authtoken']['project_domain_name'].nil?
        creds['project_domain_name'] = conf['keystone_authtoken']['project_domain_name'].strip
      else
        creds['project_domain_name'] = 'Default'
      end

      if !conf['keystone_authtoken']['user_domain_name'].nil?
        creds['user_domain_name'] = conf['keystone_authtoken']['user_domain_name'].strip
      else
        creds['user_domain_name'] = 'Default'
      end

      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required sections.  Glance types will not work if glance is not " +
            "correctly configured.")
    end
  end

  def self.get_auth_endpoint
    g = glance_credentials
    "#{g['auth_url']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.reset
    @glance_conf = nil
    @glance_credentials = nil
  end

  # To keep backward compatibility
  def self.glance_file
    self.class.glance_conf
  end

  def self.glance_hash
    @glance_hash ||= build_glance_hash
  end

  def bool_to_sym(bool)
    bool == true ? :true : :false
  end

end
