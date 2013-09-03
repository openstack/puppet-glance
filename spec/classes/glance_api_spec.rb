require 'spec_helper'

describe 'glance::api' do

  let :facts do
    {
      :osfamily => 'Debian',
      :processorcount => '7',
    }
  end

  let :default_params do
    {
      :verbose           => false,
      :debug             => false,
      :bind_host         => '0.0.0.0',
      :bind_port         => '9292',
      :registry_host     => '0.0.0.0',
      :registry_port     => '9191',
      :log_file          => '/var/log/glance/api.log',
      :auth_type         => 'keystone',
      :enabled           => true,
      :backlog           => '4096',
      :workers           => '7',
      :auth_host         => '127.0.0.1',
      :auth_port         => '35357',
      :auth_protocol     => 'http',
      :auth_uri          => 'http://127.0.0.1:5000/',
      :keystone_tenant   => 'services',
      :keystone_user     => 'glance',
      :keystone_password => 'ChangeMe',
      :sql_idle_timeout  => '3600',
      :sql_connection    => 'sqlite:///var/lib/glance/glance.sqlite'
    }
  end

  [{:keystone_password => 'ChangeMe'},
   {
      :verbose           => true,
      :debug             => true,
      :bind_host         => '127.0.0.1',
      :bind_port         => '9222',
      :registry_host     => '127.0.0.1',
      :registry_port     => '9111',
      :log_file          => '/var/log/glance-api.log',
      :auth_type         => 'not_keystone',
      :enabled           => false,
      :backlog           => '4095',
      :workers           => '5',
      :auth_host         => '127.0.0.2',
      :auth_port         => '35358',
      :auth_protocol     => 'https',
      :auth_uri          => 'https://127.0.0.2:5000/v2.0/',
      :keystone_tenant   => 'admin2',
      :keystone_user     => 'admin2',
      :keystone_password => 'ChangeMe2',
      :sql_idle_timeout  => '36002',
      :sql_connection    => 'mysql:///var:lib@glance/glance'
    }
  ].each do |param_set|

    describe "when #{param_set == {:keystone_password => 'ChangeMe'} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it { should contain_class 'glance' }

      it { should contain_service('glance-api').with(
        'ensure'     => param_hash[:enabled] ? 'running': 'stopped',
        'enable'     => param_hash[:enabled],
        'hasstatus'  => true,
        'hasrestart' => true
      ) }

      it 'should lay down default api config' do
        [
          'verbose',
          'debug',
          'bind_host',
          'bind_port',
          'log_file',
          'registry_host',
          'registry_port'
        ].each do |config|
          should contain_glance_api_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
        end
      end

      it 'should lay down default cache config' do
        [
          'verbose',
          'debug',
          'registry_host',
          'registry_port'
        ].each do |config|
          should contain_glance_cache_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
        end
      end

      it 'should config db' do
        should contain_glance_api_config('DEFAULT/sql_connection').with_value(param_hash[:sql_connection])
        should contain_glance_api_config('DEFAULT/sql_idle_timeout').with_value(param_hash[:sql_idle_timeout])
      end

      it 'should lay down default auth config' do
        [
          'auth_host',
          'auth_port',
          'auth_protocol'
        ].each do |config|
          should contain_glance_api_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
        end
      end
      it { should contain_glance_api_config('keystone_authtoken/auth_admin_prefix').with_ensure('absent') }

      it 'should configure itself for keystone if that is the auth_type' do
        if params[:auth_type] == 'keystone'
          should contain('paste_deploy/flavor').with_value('keystone+cachemanagement')
          ['admin_tenant_name', 'admin_user', 'admin_password'].each do |config|
            should contain_glance_api_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
          end
          ['admin_tenant_name', 'admin_user', 'admin_password'].each do |config|
            should contain_glance_cache_config("keystone_authtoken/#{config}").with_value(param_hash[config.intern])
          end
        end
      end
    end
  end

  describe 'with overridden pipeline' do
    let :params do
      {
        :keystone_password => 'ChangeMe',
        :pipeline          => 'keystone',
      }
    end

    it { should contain_glance_api_config('paste_deploy/flavor').with_value('keystone') }
  end

  describe 'with blank pipeline' do
    let :params do
      {
        :keystone_password => 'ChangeMe',
        :pipeline          => '',
      }
    end

    it { should contain_glance_api_config('paste_deploy/flavor').with_ensure('absent') }
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
          :pipeline          => pipeline
        }
      end

      it { expect { should contain_glance_api_config('filter:paste_deploy/flavor') }.to\
        raise_error(Puppet::Error, /validate_re\(\): .* does not match/) }
    end
  end

  describe 'with overriden auth_admin_prefix' do
    let :params do
      {
        :keystone_password => 'ChangeMe',
        :auth_admin_prefix => '/keystone/main'
      }
    end

    it { should contain_glance_api_config('keystone_authtoken/auth_admin_prefix').with_value('/keystone/main') }
  end

  [
    '/keystone/',
    'keystone/',
    'keystone',
    '/keystone/admin/',
    'keystone/admin/',
    'keystone/admin'
  ].each do |auth_admin_prefix|
    describe "with auth_admin_prefix_containing incorrect value #{auth_admin_prefix}" do
      let :params do
        {
          :keystone_password => 'ChangeMe',
          :auth_admin_prefix => auth_admin_prefix
        }
      end

      it { expect { should contain_glance_api_config('filter:authtoken/auth_admin_prefix') }.to\
        raise_error(Puppet::Error, /validate_re\(\): "#{auth_admin_prefix}" does not match/) }
    end
  end

  describe 'with syslog disabled by default' do
    let :params do
      default_params
    end

    it { should contain_glance_api_config('DEFAULT/use_syslog').with_value(false) }
    it { should_not contain_glance_api_config('DEFAULT/syslog_log_facility') }
  end

  describe 'with syslog enabled' do
    let :params do
      default_params.merge({
        :use_syslog   => 'true',
      })
    end

    it { should contain_glance_api_config('DEFAULT/use_syslog').with_value(true) }
    it { should contain_glance_api_config('DEFAULT/syslog_log_facility').with_value('LOG_USER') }
  end

  describe 'with syslog enabled and custom settings' do
    let :params do
      default_params.merge({
        :use_syslog   => 'true',
        :log_facility => 'LOG_LOCAL0'
     })
    end

    it { should contain_glance_api_config('DEFAULT/use_syslog').with_value(true) }
    it { should contain_glance_api_config('DEFAULT/syslog_log_facility').with_value('LOG_LOCAL0') }
  end

end
