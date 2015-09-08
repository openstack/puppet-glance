require 'puppet'
require 'puppet/type/glance_registry_config'

describe 'Puppet::Type.type(:glance_registry_config)' do
  before :each do
    @glance_registry_config = Puppet::Type.type(:glance_registry_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'glance-registry')
    catalog.add_resource package, @glance_registry_config
    dependency = @glance_registry_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@glance_registry_config)
    expect(dependency[0].source).to eq(package)
  end

end
