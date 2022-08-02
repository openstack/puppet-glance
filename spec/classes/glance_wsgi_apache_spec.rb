require 'spec_helper'

describe 'glance::wsgi::apache' do
  shared_examples 'apache serving glance with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('glance::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :bind_port                   => 9292,
        :group                       => 'glance',
        :path                        => '/',
        :priority                    => 10,
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'glance',
        :workers                     => facts[:os_workers],
        :wsgi_chunked_request        => 'On',
        :wsgi_daemon_process         => 'glance-api',
        :wsgi_process_group          => 'glance-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'glance-api',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :headers                     => nil,
        :request_headers             => nil,
        :custom_wsgi_process_options => {},
        :access_log_file             => nil,
        :access_log_pipe             => nil,
        :access_log_syslog           => nil,
        :access_log_format           => nil,
        :error_log_file              => nil,
        :error_log_pipe              => nil,
        :error_log_syslog            => nil,
      )}
    end

    context'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :vhost_custom_fragment       => 'Timeout 99',
          :wsgi_process_display_name   => 'glance-api',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/admin/path',
          },
          :headers                     => ['set X-XSS-Protection "1; mode=block"'],
          :request_headers             => ['set Content-Type "application/json"'],
        }
      end
      it { is_expected.to contain_class('glance::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'glance',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => true,
        :threads                   => 1,
        :user                      => 'glance',
        :vhost_custom_fragment     => 'Timeout 99',
        :workers                   => 37,
        :wsgi_chunked_request      => 'On',
        :wsgi_daemon_process       => 'glance-api',
        :wsgi_process_display_name => 'glance-api',
        :wsgi_process_group        => 'glance-api',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'glance-api',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :headers                   => ['set X-XSS-Protection "1; mode=block"'],
        :request_headers           => ['set Content-Type "application/json"'],
        :custom_wsgi_process_options => {
          'python_path'  => '/my/python/admin/path',
        },
      )}
    end

    context 'with custom access logging' do
      let :params do
        {
          :access_log_format => 'foo',
          :access_log_syslog => 'syslog:local0',
          :error_log_syslog  => 'syslog:local1',
        }
      end

      it { should contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :access_log_format => params[:access_log_format],
        :access_log_syslog => params[:access_log_syslog],
        :error_log_syslog  => params[:error_log_syslog],
      )}
    end

    context 'with access_log_file' do
      let :params do
        {
          :access_log_file => '/path/to/file',
        }
      end

      it { should contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :access_log_file => params[:access_log_file],
      )}
    end

    context 'with access_log_pipe' do
      let :params do
        {
          :access_log_pipe => 'pipe',
        }
      end

      it { should contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :access_log_pipe => params[:access_log_pipe],
      )}
    end

    context 'with error_log_file' do
      let :params do
        {
          :error_log_file => '/path/to/file',
        }
      end

      it { should contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :error_log_file => params[:error_log_file],
      )}
    end

    context 'with error_log_pipe' do
      let :params do
        {
          :error_log_pipe => 'pipe',
        }
      end

      it { should contain_openstacklib__wsgi__apache('glance_wsgi').with(
        :error_log_pipe => params[:error_log_pipe],
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/glance',
            :wsgi_script_source => '/usr/bin/glance-wsgi-api'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/glance',
            :wsgi_script_source => '/usr/bin/glance-wsgi-api'
          }
        end
      end

      it_behaves_like 'apache serving glance with mod_wsgi'
    end
  end
end
