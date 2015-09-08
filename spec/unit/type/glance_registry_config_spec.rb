require 'puppet'
require 'puppet/type/glance_registry_config'

describe 'Puppet::Type.type(:glance_registry_config)' do
  before :each do
    Puppet::Type.rmtype(:glance_registry_config)
    Facter.fact(:osfamily).stubs(:value).returns(platform_params[:osfamily])
    @glance_registry_config = Puppet::Type.type(:glance_registry_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  shared_examples_for 'glance_registry_config' do
    it 'should autorequire the package that install the file' do
      catalog = Puppet::Resource::Catalog.new
      package = Puppet::Type.type(:package).new(:name => platform_params[:package_name])
      catalog.add_resource package, @glance_registry_config
      dependency = @glance_registry_config.autorequire
      expect(dependency.size).to eq(1)
      expect(dependency[0].target).to eq(@glance_registry_config)
      expect(dependency[0].source).to eq(package)
    end
  end

  context 'on Debian platforms' do
    let :platform_params do
      { :package_name => 'glance-registry',
        :osfamily     => 'Debian' }
    end

    it_behaves_like 'glance_registry_config'
  end

  context 'on RedHat platforms' do
    let :platform_params do
      { :package_name => 'openstack-glance',
        :osfamily     => 'RedHat'}
    end

    it_behaves_like 'glance_registry_config'
  end

end
