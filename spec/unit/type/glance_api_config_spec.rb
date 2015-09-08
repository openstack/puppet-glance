require 'puppet'
require 'puppet/type/glance_api_config'

describe 'Puppet::Type.type(:glance_api_config)' do
  before :each do
    @glance_api_config = Puppet::Type.type(:glance_api_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'glance-api')
    catalog.add_resource package, @glance_api_config
    dependency = @glance_api_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@glance_api_config)
    expect(dependency[0].source).to eq(package)
  end

end
