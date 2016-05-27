require 'puppet'
require 'spec_helper'
require 'puppet/provider/glance_image/openstack'

provider_class = Puppet::Type.type(:glance_image).provider(:openstack)

describe provider_class do

  shared_examples 'authenticated with environment variables' do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:35357/v2.0'
  end

  describe 'when managing an image' do

    let(:tenant_attrs) do
      {
        :ensure           => 'present',
        :name             => 'image1',
        :is_public        => 'yes',
        :container_format => 'bare',
        :disk_format      => 'qcow2',
        :source           => 'http://example.com/image1.img',
        :min_ram          => 1024,
        :min_disk         => 1024,
      }
    end

    let(:resource) do
      Puppet::Type::Glance_image.new(tenant_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
                        .with('image', 'create', '--format', 'shell', ['image1', '--public', '--container-format=bare', '--disk-format=qcow2', '--min-disk=1024', '--min-ram=1024', '--copy-from=http://example.com/image1.img' ])
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
is_public="True"
min_disk="1024"
min_ram="1024"
name="image1"
owner="None"
properties="{}"
protected="False"
size="1270"
status="active"
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
      end
    end

  end

  describe 'when managing an image with properties' do

    let(:tenant_attrs) do
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
      Puppet::Type::Glance_image.new(tenant_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
                        .with('image', 'create', '--format', 'shell', ['image1', '--public', '--container-format=bare', '--disk-format=qcow2', '--min-disk=1024', '--min-ram=1024', ['--property', 'something=what', '--property', 'vmware_disktype=sparse'], '--file=/var/tmp/image1.img' ])
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
properties="something=\'what\', vmware_disktype=\'sparse\'"
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
is_public="True"
min_disk="1024"
min_ram="1024"
name="image1"
owner="None"
properties="something=\'what\', vmware_disktype=\'sparse\'"
protected="False"
size="1270"
status="active"
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
      end
    end

  end

  describe 'when creating an image with id' do

    let(:tenant_attrs) do
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
      Puppet::Type::Glance_image.new(tenant_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#create' do
        it 'creates an image' do
          provider.class.stubs(:openstack)
                        .with('image', 'create', '--format', 'shell', ['image1', '--public', '--container-format=bare', '--disk-format=qcow2', '--id=2b4be0b8-aec0-43af-a404-33c3335a0b3f', '--file=/var/tmp/image1.img' ])
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
properties="{}"
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
                      .with('image', 'show', '--format', 'shell', '2b4be0b8-aec0-43af-a404-33c3335a0b3f')
                      .returns('checksum="09b9c392dc1f6e914cea287cb6be34b0"
container_format="bare"
created_at="2015-04-08T18:28:01"
deleted="False"
deleted_at="None"
disk_format="qcow2"
id="2b4be0b8-aec0-43af-a404-33c3335a0b3f"
min_disk="0"
min_ram="0"
is_public="True"
name="image1"
owner="None"
properties="{}"
protected="False"
size="1270"
status="active"
updated_at="2015-04-10T18:18:18"
virtual_size="None"
')
        instances = provider_class.instances
        expect(instances.count).to eq(1)
      end
    end

  end

end
