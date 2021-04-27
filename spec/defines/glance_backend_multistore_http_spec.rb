#
# Copyright 2020 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for glance::backend::multistore::http
#

require 'spec_helper'

describe 'glance::backend::multistore::http' do
  let (:title) { 'http' }

  shared_examples 'glance::backend::multistore::http' do
    context 'with default params' do
      it 'sets the default values' do
        should contain_glance_api_config('http/https_ca_certificates_file')\
          .with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('http/https_insecure').with_value('<SERVICE DEFAULT>')
        should contain_glance_api_config('http/http_proxy_information')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when passing params' do
      let :params do
        {
          :https_ca_certificates_file => '/etc/glance/https_ca_cert.pem',
          :https_insecure             => true,
          :http_proxy_information     => ['http:10.0.0.1:3128', 'https:10.0.0.1:1080'],
        }
      end

      it 'sets the given values' do
        should contain_glance_api_config('http/https_ca_certificates_file')\
          .with_value('/etc/glance/https_ca_cert.pem')
        should contain_glance_api_config('http/https_insecure').with_value(true)
        should contain_glance_api_config('http/http_proxy_information')\
          .with_value('http:10.0.0.1:3128,https:10.0.0.1:1080')
      end
    end

    context 'when multiple http backends are defined' do
      let :pre_condition do
        <<-eos
        glance::backend::multistore::http{ 'anotherhttp': }
eos
      end

      it 'fails to apply the requested configuration' do
        should raise_error(Puppet::Error, /Glance accepts only one http store./)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::backend::multistore::http'
    end
  end
end
