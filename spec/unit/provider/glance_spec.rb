require 'puppet'
require 'spec_helper'
require 'puppet/provider/glance'
require 'tempfile'


klass = Puppet::Provider::Glance

class Puppet::Provider::Glance
  def self.reset
    @admin_endpoint = nil
    @tenant_hash    = nil
    @admin_token    = nil
    @keystone_file  = nil
  end
end

describe Puppet::Provider::Glance do

  after :each do
    klass.reset
  end

  describe 'when retrieving the auth credentials' do

    it 'should fail if no auth params are passed and the glance config file does not have the expected contents' do
      mock = {}
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/glance/glance-api.conf')
      expect do
        klass.glance_credentials
      end.to raise_error(Puppet::Error, /does not contain all required sections/)
    end

  end

end
