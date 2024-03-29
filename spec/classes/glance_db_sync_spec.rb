require 'spec_helper'

describe 'glance::db::sync' do

  shared_examples_for 'glance-dbsync' do

    it { is_expected.to contain_class('glance::deps') }

    it 'runs glance-manage db_sync' do
      is_expected.to contain_exec('glance-manage db_sync').with(
        :command     => 'glance-manage  db_sync',
        :path        => '/usr/bin',
        :user        => 'glance',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[glance::install::end]',
                         'Anchor[glance::config::end]',
                         'Anchor[glance::dbsync::begin]'],
        :notify      => 'Anchor[glance::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params    => '--config-file /etc/glance/glance.conf',
          :db_sync_timeout => 750,
        }
      end

      it {is_expected.to contain_exec('glance-manage db_sync').with(
        :command     => 'glance-manage --config-file /etc/glance/glance.conf db_sync',
        :path        => '/usr/bin',
        :user        => 'glance',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 750,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[glance::install::end]',
                         'Anchor[glance::config::end]',
                         'Anchor[glance::dbsync::begin]'],
        :notify      => 'Anchor[glance::dbsync::end]',
        :tag         => 'openstack-db',
      )
      }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance-dbsync'
    end
  end

end
