require 'spec_helper'

describe 'glance::policy' do
  shared_examples 'glance::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/glance/policy.yaml',
          :policy_dirs          => '/etc/glance/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/glance/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/glance/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'glance',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => 'glance',
        )
        is_expected.to contain_oslo__policy('glance_api_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/glance/policy.yaml',
          :policy_dirs          => '/etc/glance/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/glance/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/glance/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/glance/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'glance',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => 'glance',
        )
        is_expected.to contain_oslo__policy('glance_api_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/glance/policy.yaml',
        )
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

      it_behaves_like 'glance::policy'
    end
  end
end
