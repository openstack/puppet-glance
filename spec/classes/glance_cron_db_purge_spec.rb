require 'spec_helper'

describe 'glance::cron::db_purge' do
  let :params do
    {
      :minute      => 1,
      :hour        => 0,
      :monthday    => '*',
      :month       => '*',
      :weekday     => '*',
      :user        => 'glance',
      :age         => '30',
      :max_rows    => 100,
      :maxdelay    => 0,
      :destination => '/var/log/glance/glance-rowsflush.log'
    }
  end

  shared_examples 'glance::cron::db_purge' do
    context 'with required parameters' do
      it { is_expected.to contain_cron('glance-manage db purge').with(
        :ensure      => :present,
        :command     => "glance-manage db purge --age_in_days #{params[:age]} --max_rows #{params[:max_rows]} >>#{params[:destination]} 2>&1",
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[glance::dbsync::end]'
      )}
    end

    context 'with ensure set to absent' do
      before :each do
        params.merge!(
          :ensure => :absent
        )
      end
      it { should contain_cron('glance-manage db purge').with_ensure(:absent) }
    end

    context 'with required parameters with max delay enabled' do
      before :each do
        params.merge!(
          :maxdelay => 600
        )
      end

      it { should contain_cron('glance-manage db purge').with(
        :ensure      => :present,
        :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; glance-manage db purge --age_in_days #{params[:age]} --max_rows #{params[:max_rows]} >>#{params[:destination]} 2>&1",
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[glance::dbsync::end]'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glance::cron::db_purge'
    end
  end
end
