# Since there's only one glance_* type for API resources now,
# this probably could have all gone in the provider file.
# But maybe this is good long-term.
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Glance < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

  def bool_to_sym(bool)
    bool == true ? :true : :false
  end

end
