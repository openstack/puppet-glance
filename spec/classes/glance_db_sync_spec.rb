require 'spec_helper'

describe 'glance::db::sync' do

  shared_examples_for 'glance-dbsync' do

    it 'runs glance-manage db_sync' do
      is_expected.to contain_exec('glance-manage db_sync').with(
        :command     => 'glance-manage --config-file /etc/glance/glance-registry.conf db_sync',
        :path        => '/usr/bin',
        :user        => 'glance',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/glance/glance.conf',
        }
      end

      it {is_expected.to contain_exec('glance-manage db_sync').with(
        :command     => 'glance-manage --config-file /etc/glance/glance.conf db_sync',
        :path        => '/usr/bin',
        :user        => 'glance',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
      }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_configures 'glance-dbsync'
    end
  end

end
