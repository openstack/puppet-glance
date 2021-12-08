require 'puppet'
require 'spec_helper'
require 'puppet/provider/glance_image/openstack'

provider_class = Puppet::Type.type(:glance_image).provider(:openstack)

describe provider_class do

  shared_examples 'authenticated with environment variables' do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000/v3'
  end

  describe 'when managing an image' do

    let(:image_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => '/var/tmp/image1.img',
        :min_ram          => 1024,
        :min_disk         => 1024,
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(image_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
            .with('image', 'create', '--format', 'shell',
                  ['image1', '--public', '--container-format=bare',
                   '--disk-format=qcow2', '--min-disk=1024', '--min-ram=1024',
                   '--file=/var/tmp/image1.img'])
            .returns('checksum="ee1eca47dc88f4879d8a229cc70a07c6"
container_format="bare"
created_at="2016-03-29T20:52:24Z"
disk_format="qcow2"
file="/v2/images/8801c5b0-c505-4a15-8ca3-1d2383f8c015/file"
id="8801c5b0-c505-4a15-8ca3-1d2383f8c015"
min_disk="1024"
min_ram="1024"
name="image1"
owner="5a9e521e17014804ab8b4e8b3de488a4"
protected="False"
schema="/v2/schemas/image"
size="13287936"
status="active"
tags=""
updated_at="2016-03-29T20:52:40Z"
virtual_size="None"
visibility="public"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end
    end

    describe '#destroy' do
      it 'destroys an image' do
        provider.class.stubs(:openstack)
                      .with('image', 'delete', 'image1')
        provider.destroy
        expect(provider.exists?).to be_falsey
      end

    end

    describe '#pythondict2hash' do
      it 'should return a hash with key-value when provided with a unicode python dict' do
        s = "{u'key': 'value', u'key2': 'value2'}"
        expect(provider_class.pythondict2hash(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end

      it 'should return a hash with key-value when provided with a python dict' do
        s = "{'key': 'value', 'key2': 'value2'}"
        expect(provider_class.pythondict2hash(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end

      it 'should convert boolean to json compatible hash when provided with a python dict' do
        s = "{'key': 'value', 'key2': False}"
        expect(provider_class.pythondict2hash(s)).to eq({"key"=>"value", "key2"=>false})
      end
    end

    describe '#parsestring' do
      it 'should call string2hash when provided with a string' do
        s = "key='value', key2='value2'"
        expect(provider_class.parsestring(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end

      it 'should call pythondict2hash when provided with a hash' do
        s = "{u'key': 'value', u'key2': 'value2'}"
        expect(provider_class.parsestring(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end
    end

    describe '.instances' do
      it 'finds every image' do
        provider.class.stubs(:openstack)
          .with('image', 'list', '--quiet', '--format', 'csv', '--long')
          .returns('"ID","Name","Disk Format","Container Format","Size","Status"
"5345b502-efe4-4852-a45d-edaba3a3acc6","image1","raw","bare",1270,"active"
')
        provider.class.stubs(:openstack)
          .with('image', 'show', '--format', 'shell',
                '5345b502-efe4-4852-a45d-edaba3a3acc6')
          .returns('checksum="09b9c392dc1f6e914cea287cb6be34b0"
container_format="bare"
created_at="2015-04-08T18:28:01"
deleted="False"
deleted_at="None"
disk_format="qcow2"
id="5345b502-efe4-4852-a45d-edaba3a3acc6"
visibility="public"
min_disk="1024"
min_ram="1024"
name="image1"
owner="None"
properties="os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
size="1270"
status="active"
tags=""
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
      end
    end

  end

  describe 'when managing an image with properties' do

    let(:image_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => '/var/tmp/image1.img',
        :min_ram          => 1024,
        :min_disk         => 1024,
        :properties       => { 'something' => 'what', 'vmware_disktype' => 'sparse' }
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(image_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
            .with('image', 'create', '--format', 'shell',
                  ['image1', '--public', '--container-format=bare',
                   '--disk-format=qcow2', '--min-disk=1024', '--min-ram=1024',
                   ['--property', 'something=what', '--property',
                    'vmware_disktype=sparse'],
                   '--file=/var/tmp/image1.img'])
            .returns('checksum="ee1eca47dc88f4879d8a229cc70a07c6"
container_format="bare"
created_at="2016-03-29T20:52:24Z"
disk_format="qcow2"
file="/v2/images/8801c5b0-c505-4a15-8ca3-1d2383f8c015/file"
id="8801c5b0-c505-4a15-8ca3-1d2383f8c015"
min_disk="1024"
min_ram="1024"
name="image1"
owner="5a9e521e17014804ab8b4e8b3de488a4"
properties="something=\'what\', vmware_disktype=\'sparse\', os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
schema="/v2/schemas/image"
size="13287936"
status="active"
tags=""
updated_at="2016-03-29T20:52:40Z"
virtual_size="None"
visibility="public"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end
    end

    describe '.instances' do
      it 'finds every image' do
        provider.class.stubs(:openstack)
          .with('image', 'list', '--quiet', '--format', 'csv', '--long')
          .returns('"ID","Name","Disk Format","Container Format","Size","Status"
"5345b502-efe4-4852-a45d-edaba3a3acc6","image1","raw","bare",1270,"active"
')
        provider.class.stubs(:openstack)
          .with('image', 'show', '--format', 'shell', '5345b502-efe4-4852-a45d-edaba3a3acc6')
          .returns('checksum="09b9c392dc1f6e914cea287cb6be34b0"
container_format="bare"
created_at="2015-04-08T18:28:01"
deleted="False"
deleted_at="None"
disk_format="qcow2"
id="5345b502-efe4-4852-a45d-edaba3a3acc6"
visibility="public"
min_disk="1024"
min_ram="1024"
name="image1"
owner="None"
properties="something=\'what\', vmware_disktype=\'sparse\', os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
size="1270"
status="active"
tags=""
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
        expect(instances[0].properties).to eq({ 'something' => 'what', 'vmware_disktype' => 'sparse' })
      end
    end

  end

  describe 'when creating an image with id' do

    let(:image_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => '/var/tmp/image1.img',
        :id               => '2b4be0b8-aec0-43af-a404-33c3335a0b3f'
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(image_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
            .with('image', 'create', '--format', 'shell',
                  ['image1', '--public', '--container-format=bare',
                   '--disk-format=qcow2',
                   '--id=2b4be0b8-aec0-43af-a404-33c3335a0b3f',
                   '--file=/var/tmp/image1.img' ])
            .returns('checksum="ee1eca47dc88f4879d8a229cc70a07c6"
container_format="bare"
created_at="2016-03-29T20:52:24Z"
disk_format="qcow2"
file="/v2/images/2b4be0b8-aec0-43af-a404-33c3335a0b3f/file"
id="2b4be0b8-aec0-43af-a404-33c3335a0b3f"
min_disk="0"
min_ram="0"
name="image1"
owner="5a9e521e17014804ab8b4e8b3de488a4"
properties="os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
schema="/v2/schemas/image"
size="13287936"
status="active"
tags=""
updated_at="2016-03-29T20:52:40Z"
virtual_size="None"
visibility="public"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end
    end

    describe '.instances' do
      it 'finds every image' do
        provider.class.stubs(:openstack)
          .with('image', 'list', '--quiet', '--format', 'csv', '--long')
          .returns('"ID","Name","Disk Format","Container Format","Size","Status"
"2b4be0b8-aec0-43af-a404-33c3335a0b3f","image1","raw","bare",1270,"active"
')
        provider.class.stubs(:openstack)
          .with('image', 'show', '--format', 'shell',
                '2b4be0b8-aec0-43af-a404-33c3335a0b3f')
          .returns('checksum="09b9c392dc1f6e914cea287cb6be34b0"
container_format="bare"
created_at="2015-04-08T18:28:01"
deleted="False"
deleted_at="None"
disk_format="qcow2"
id="2b4be0b8-aec0-43af-a404-33c3335a0b3f"
min_disk="0"
min_ram="0"
visibility="public"
name="image1"
owner="None"
properties="os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
size="1270"
status="active"
tags=""
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
      end
    end

  end

  describe 'when creating an image with owner' do

    let(:image_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => '/var/tmp/image1.img',
        :project_id       => '5a9e521e17014804ab8b4e8b3de488a4'
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(image_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
            .with('image', 'create', '--format', 'shell',
                  ['image1', '--public', '--container-format=bare',
                   '--disk-format=qcow2',
                   '--file=/var/tmp/image1.img',
                   '--project=5a9e521e17014804ab8b4e8b3de488a4'])
            .returns('checksum="ee1eca47dc88f4879d8a229cc70a07c6"
container_format="bare"
created_at="2016-03-29T20:52:24Z"
disk_format="qcow2"
file="/v2/images/2b4be0b8-aec0-43af-a404-33c3335a0b3f/file"
id="2b4be0b8-aec0-43af-a404-33c3335a0b3f"
min_disk="0"
min_ram="0"
name="image1"
owner="5a9e521e17014804ab8b4e8b3de488a4"
properties="os_hash_algo=\'abc123\', os_hash_value=\'test123\', os_hidden=\'true\'"
protected="False"
schema="/v2/schemas/image"
size="13287936"
status="active"
tags=""
updated_at="2016-03-29T20:52:40Z"
virtual_size="None"
visibility="public"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end
    end
  end

  describe 'when creating image with tag' do

    let(:image_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => '/var/tmp/image1.img',
        :image_tag        => 'testtag',
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(image_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
            .with('image', 'create', '--format', 'shell',
                  ['image1', '--public', '--container-format=bare',
                   '--disk-format=qcow2', '--tag=testtag',
                   '--file=/var/tmp/image1.img' ])
            .returns('checksum="ee1eca47dc88f4879d8a229cc70a07c6"
container_format="bare"
created_at="2016-03-29T20:52:24Z"
disk_format="qcow2"
file="/v2/images/8801c5b0-c505-4a15-8ca3-1d2383f8c015/file"
id="8801c5b0-c505-4a15-8ca3-1d2383f8c015"
name="image1"
owner="5a9e521e17014804ab8b4e8b3de488a4"
protected="False"
schema="/v2/schemas/image"
size="13287936"
status="active"
tags="testtag"
updated_at="2016-03-29T20:52:40Z"
virtual_size="None"
visibility="public"
')
          provider.create
          expect(provider.exists?).to be_truthy
          expect(provider.image_tag).to eq('testtag')
        end
      end
    end

    describe '.instances' do
      it 'finds every image' do
        provider.class.stubs(:openstack)
          .with('image', 'list', '--quiet', '--format', 'csv', '--long')
          .returns('"ID","Name","Disk Format","Container Format","Size","Status","Tags"
"5345b502-efe4-4852-a45d-edaba3a3acc6","image1","raw","bare",1270,"active","testtag"
')
        provider.class.stubs(:openstack)
          .with('image', 'show', '--format', 'shell', '5345b502-efe4-4852-a45d-edaba3a3acc6')
          .returns('checksum="09b9c392dc1f6e914cea287cb6be34b0"
container_format="bare"
created_at="2015-04-08T18:28:01"
deleted="False"
deleted_at="None"
disk_format="qcow2"
id="5345b502-efe4-4852-a45d-edaba3a3acc6"
visibility="public"
name="image1"
owner="None"
tags="testtag"
protected="False"
size="1270"
status="active"
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
        expect(instances[0].image_tag).to eq('testtag')
      end
    end

  end

end
