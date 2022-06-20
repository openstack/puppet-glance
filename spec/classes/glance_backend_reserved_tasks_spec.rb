require 'spec_helper'

describe 'glance::backend::reserved::tasks' do

  shared_examples_for 'glance::backend::reserved::tasks' do
    it 'configures glance-api.conf' do
      is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_datadir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_file_perm').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_chunk_size').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_thin_provisioning').with_value('<SERVICE DEFAULT>')
    end

    describe 'when overriding datadir' do
      let :params do
        {
          :filesystem_store_datadir     => '/var/lib/glance/tasks',
          :filesystem_store_file_perm   => 0,
          :filesystem_store_chunk_size  => 65536,
          :filesystem_thin_provisioning => true,
        }
      end

      it 'configures glance-api.conf' do
        is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_datadir')\
          .with_value('/var/lib/glance/tasks')
        is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_file_perm')\
          .with_value(0)
        is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_store_chunk_size')\
          .with_value(65536)
        is_expected.to contain_glance_api_config('os_glance_tasks_store/filesystem_thin_provisioning')\
          .with_value(true)
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance::backend::reserved::tasks'
    end
  end
end
