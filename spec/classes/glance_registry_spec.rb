
describe 'glance::registry' do
  let :default_params do
    {
      :verbose                => false,
      :debug                  => false,
      :use_stderr             => true,
      :bind_host              => '0.0.0.0',
      :bind_port              => '9191',
      :workers                => facts[:processorcount],
      :log_file               => '/var/log/glance/registry.log',
      :log_dir                => '/var/log/glance',
      :enabled                => true,
      :manage_service         => true,
      :auth_type              => 'keystone',
      :auth_uri               => 'http://127.0.0.1:5000/',
      :identity_uri           => 'http://127.0.0.1:35357/',
      :keystone_tenant        => 'services',
      :keystone_user          => 'glance',
      :keystone_password      => 'ChangeMe',
      :purge_config           => false,
      :sync_db                => true,
      :os_region_name         => '<SERVICE DEFAULT>',
      :signing_dir            => '<SERVICE DEFAULT>',
      :token_cache_time       => '<SERVICE DEFAULT>',
      :memcached_servers      => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'glance::registry' do
    [
      {:keystone_password => 'ChangeMe'},
      {
        :bind_host              => '127.0.0.1',
        :bind_port              => '9111',
        :workers                => '5',
        :enabled                => false,
        :auth_type              => 'keystone',
        :auth_uri               => 'http://127.0.0.1:5000/v2.0',
        :identity_uri           => 'http://127.0.0.1:35357/v2.0',
        :keystone_tenant        => 'admin',
        :keystone_user          => 'admin',
        :keystone_password      => 'ChangeMe',
        :sync_db                => false,
        :os_region_name         => 'RegionOne2',
        :signing_dir            => '/path/to/dir',
        :token_cache_time       => '300',
      }
    ].each do |param_set|

      describe "when #{param_set == {:keystone_password => 'ChangeMe'} ? "using default" : "specifying"} class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { is_expected.to contain_class 'glance::registry' }
        it { is_expected.to contain_class 'glance::registry::db' }
        it { is_expected.to contain_class 'glance::registry::logging' }

      it { is_expected.to contain_service('glance-registry').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running' : 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'require'    => 'Class[Glance]',
          'tag'        => 'glance-service',
      )}

        it 'is_expected.to not sync the db if sync_db is set to false' do

          if !param_hash[:sync_db]
            is_expected.not_to contain_exec('glance-manage db_sync')
          end
        end
        it 'is_expected.to configure itself' do
          [
           'workers',
           'bind_port',
           'bind_host',
          ].each do |config|
            is_expected.to contain_glance_registry_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
          [
           'auth_uri',
           'identity_uri'
          ].each do |config|
            is_expected.to contain_glance_registry_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
          end
          if param_hash[:auth_type] == 'keystone'
            is_expected.to contain_glance_registry_config("paste_deploy/flavor").with_value('keystone')
            is_expected.to contain_glance_registry_config('keystone_authtoken/memcached_servers').with_value(param_hash[:memcached_servers])
            is_expected.to contain_glance_registry_config("keystone_authtoken/admin_tenant_name").with_value(param_hash[:keystone_tenant])
            is_expected.to contain_glance_registry_config("keystone_authtoken/admin_user").with_value(param_hash[:keystone_user])
            is_expected.to contain_glance_registry_config("keystone_authtoken/admin_password").with_value(param_hash[:keystone_password])
            is_expected.to contain_glance_registry_config("keystone_authtoken/admin_password").with_value(param_hash[:keystone_password]).with_secret(true)
            is_expected.to contain_glance_registry_config("keystone_authtoken/token_cache_time").with_value(param_hash[:token_cache_time])
            is_expected.to contain_glance_registry_config("keystone_authtoken/signing_dir").with_value(param_hash[:signing_dir])
          end
        end
        it 'is_expected.to lay down default glance_store registry config' do
          [
            'os_region_name',
          ].each do |config|
            is_expected.to contain_glance_registry_config("glance_store/#{config}").with_value(param_hash[config.intern])
          end
        end
      end
    end

    describe 'with disabled service managing' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :manage_service => false,
          :enabled        => false,
        }
      end

      it { is_expected.to contain_service('glance-registry').with(
            'ensure'     => nil,
            'enable'     => false,
            'hasstatus'  => true,
            'hasrestart' => true,
            'require'    => 'Class[Glance]',
            'tag'        => 'glance-service',
        )}
    end

    describe 'with overridden pipeline' do
      # At the time of writing there was only blank and keystone as options
      # but there is no reason that there can't be more options in the future.
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => 'validoptionstring',
        }
      end

      it { is_expected.to contain_glance_registry_config('paste_deploy/flavor').with_value('validoptionstring') }
    end

    describe 'with blank pipeline' do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :pipeline          => '',
        }
      end

      it { is_expected.to contain_glance_registry_config('paste_deploy/flavor').with_ensure('absent') }
    end

    [
      'keystone/',
      'keystone+',
      '+keystone',
      'keystone+cachemanagement+',
      '+'
    ].each do |pipeline|
      describe "with pipeline incorrect value #{pipeline}" do
        let :params do
          {
            :keystone_password => 'ChangeMe',
            :auth_type         => 'keystone',
            :pipeline          => pipeline
          }
        end

        it { expect { is_expected.to contain_glance_registry_config('filter:paste_deploy/flavor') }.to\
          raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
      end
    end

    describe 'with ssl options' do
      let :params do
        default_params.merge({
          :ca_file     => '/tmp/ca_file',
          :cert_file   => '/tmp/cert_file',
          :key_file    => '/tmp/key_file'
        })
      end

      context 'with ssl options' do
        it { is_expected.to contain_glance_registry_config('DEFAULT/ca_file').with_value('/tmp/ca_file') }
        it { is_expected.to contain_glance_registry_config('DEFAULT/cert_file').with_value('/tmp/cert_file') }
        it { is_expected.to contain_glance_registry_config('DEFAULT/key_file').with_value('/tmp/key_file') }
      end
    end
  end

  shared_examples_for 'glance::registry Debian' do
    # We only test this on Debian platforms, since on RedHat there isn't a
    # separate package for glance registry.
    ['present', 'latest'].each do |package_ensure|
      context "with package_ensure '#{package_ensure}'" do
        let(:params) { default_params.merge({ :package_ensure => package_ensure }) }
        it { is_expected.to contain_package('glance-registry').with(
            :ensure => package_ensure,
            :tag    => ['openstack', 'glance-package']
        )}
      end
    end
  end

  shared_examples_for 'glance::registry RedHat' do
    let(:params) { default_params }

    it { is_expected.to contain_package('openstack-glance') }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::registry'
      it_configures "glance::registry #{facts[:osfamily]}"
    end
  end

  describe 'on unknown platforms' do
    let :facts do
      { :osfamily => 'unknown' }
    end
    let(:params) { default_params }

    it_raises 'a Puppet::Error', /module glance only support osfamily RedHat and Debian/
  end

end
