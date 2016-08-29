# Since there's only one glance type for now,
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
    @credentials.username = glance_credentials['username']
    @credentials.password = glance_credentials['password']
    @credentials.project_name = glance_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.glance_credentials
    @glance_credentials ||= get_glance_credentials
  end

  def self.get_glance_credentials
    if glance_file and glance_file['keystone_authtoken'] and
      glance_file['keystone_authtoken']['auth_host'] and
      glance_file['keystone_authtoken']['auth_port'] and
      glance_file['keystone_authtoken']['auth_protocol'] and
      glance_file['keystone_authtoken']['project_name'] and
      glance_file['keystone_authtoken']['username'] and
      glance_file['keystone_authtoken']['password'] and
      glance_file['glance_store']['os_region_name']

        g = {}
        g['auth_host'] = glance_file['keystone_authtoken']['auth_host'].strip
        g['auth_port'] = glance_file['keystone_authtoken']['auth_port'].strip
        g['auth_protocol'] = glance_file['keystone_authtoken']['auth_protocol'].strip
        g['project_name'] = glance_file['keystone_authtoken']['project_name'].strip
        g['username'] = glance_file['keystone_authtoken']['username'].strip
        g['password'] = glance_file['keystone_authtoken']['password'].strip
        g['os_region_name'] = glance_file['glance_store']['os_region_name'].strip

        # auth_admin_prefix not required to be set.
        g['auth_admin_prefix'] = (glance_file['keystone_authtoken']['auth_admin_prefix'] || '').strip

        return g
    elsif glance_file and glance_file['keystone_authtoken'] and
      glance_file['keystone_authtoken']['auth_url'] and
      glance_file['keystone_authtoken']['project_name'] and
      glance_file['keystone_authtoken']['username'] and
      glance_file['keystone_authtoken']['password'] and
      glance_file['glance_store']['os_region_name']

        g = {}
        g['auth_url'] = glance_file['keystone_authtoken']['auth_url'].strip
        g['project_name'] = glance_file['keystone_authtoken']['project_name'].strip
        g['username'] = glance_file['keystone_authtoken']['username'].strip
        g['password'] = glance_file['keystone_authtoken']['password'].strip
        g['os_region_name'] = glance_file['glance_store']['os_region_name'].strip

        return g
    else
      raise(Puppet::Error, 'File: /etc/glance/glance-api.conf does not contain all required sections.')
    end
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.get_auth_endpoint
    g = glance_credentials
    if g.key?('auth_url')
      "#{g['auth_url']}/"
    else
      "#{g['auth_protocol']}://#{g['auth_host']}:#{g['auth_port']}#{g['auth_admin_prefix']}/v2.0/"
    end
  end

  def self.glance_file
    return @glance_file if @glance_file
    @glance_file = Puppet::Util::IniConfig::File.new
    @glance_file.read('/etc/glance/glance-api.conf')
    @glance_file
  end

  def self.glance_hash
    @glance_hash ||= build_glance_hash
  end

  def bool_to_sym(bool)
    bool == true ? :true : :false
  end

end
