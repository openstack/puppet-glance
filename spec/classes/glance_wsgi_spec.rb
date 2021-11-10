require 'spec_helper'

describe 'glance::wsgi' do
  shared_examples 'glance::wsgi' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_glance_api_config('wsgi/task_pool_threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glance_api_config('wsgi/python_interpreter').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specified parameters' do
      let :params do
        {
          :task_pool_threads  => 16,
          :python_interpreter => '/usr/bin/python3'
        }
      end

      it 'configures the default values' do
        is_expected.to contain_glance_api_config('wsgi/task_pool_threads').with_value(16)
        is_expected.to contain_glance_api_config('wsgi/python_interpreter').with_value('/usr/bin/python3')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::wsgi'
    end
  end
end
