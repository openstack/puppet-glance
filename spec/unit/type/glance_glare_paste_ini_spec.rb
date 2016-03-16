require 'puppet'
require 'puppet/type/glance_glare_paste_ini'

describe 'Puppet::Type.type(:glance_glare_paste_ini)' do
  before :each do
    Puppet::Type.rmtype(:glance_glare_paste_ini)
    Facter.fact(:osfamily).stubs(:value).returns(platform_params[:osfamily])
    @glance_glare_paste_ini = Puppet::Type.type(:glance_glare_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  shared_examples_for 'glance_glare_paste_ini' do

    it 'should require a name' do
      expect {
        Puppet::Type.type(:glance_glare_paste_ini).new({})
      }.to raise_error(Puppet::Error, 'Title or name must be provided')
    end

    it 'should not expect a name with whitespace' do
      expect {
        Puppet::Type.type(:glance_glare_paste_ini).new(:name => 'f oo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should fail when there is no section' do
      expect {
        Puppet::Type.type(:glance_glare_paste_ini).new(:name => 'foo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should not require a value when ensure is absent' do
      Puppet::Type.type(:glance_glare_paste_ini).new(:name => 'DEFAULT/foo', :ensure => :absent)
    end

    it 'should accept a valid value' do
      @glance_glare_paste_ini[:value] = 'bar'
      expect(@glance_glare_paste_ini[:value]).to eq('bar')
    end

    it 'should not accept a value with whitespace' do
      @glance_glare_paste_ini[:value] = 'b ar'
      expect(@glance_glare_paste_ini[:value]).to eq('b ar')
    end

    it 'should accept valid ensure values' do
      @glance_glare_paste_ini[:ensure] = :present
      expect(@glance_glare_paste_ini[:ensure]).to eq(:present)
      @glance_glare_paste_ini[:ensure] = :absent
      expect(@glance_glare_paste_ini[:ensure]).to eq(:absent)
    end

    it 'should not accept invalid ensure values' do
      expect {
        @glance_glare_paste_ini[:ensure] = :latest
      }.to raise_error(Puppet::Error, /Invalid value/)
    end

    it 'should autorequire the package that install the file' do
      catalog = Puppet::Resource::Catalog.new
      package = Puppet::Type.type(:package).new(:name => platform_params[:package_name])
      catalog.add_resource package, @glance_glare_paste_ini
      dependency = @glance_glare_paste_ini.autorequire
      expect(dependency.size).to eq(1)
      expect(dependency[0].target).to eq(@glance_glare_paste_ini)
      expect(dependency[0].source).to eq(package)
    end
  end

  context 'on Debian platforms' do
    let :platform_params do
      { :package_name => 'glance-glare',
        :osfamily     => 'Debian' }
    end

    it_behaves_like 'glance_glare_paste_ini'
  end

  context 'on RedHat platforms' do
    let :platform_params do
      { :package_name => 'openstack-glance',
        :osfamily     => 'RedHat'}
    end

    it_behaves_like 'glance_glare_paste_ini'
  end

end
