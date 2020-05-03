require 'puppet'
require 'puppet/type/glance_registry_config'

describe 'Puppet::Type.type(:glance_registry_config)' do
  before :each do
    @glance_registry_config = Puppet::Type.type(:glance_registry_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'glance::install::end')
    catalog.add_resource anchor, @glance_registry_config
    dependency = @glance_registry_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@glance_registry_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
