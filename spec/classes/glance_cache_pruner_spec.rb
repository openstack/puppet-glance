require 'spec_helper'

describe 'glance::cache::pruner' do

  shared_examples_for 'glance cache pruner' do

    context 'when default parameters' do

      it 'configures a cron' do
         is_expected.to contain_cron('glance-cache-pruner').with(
          :ensure      => :present,
          :command     => 'glance-cache-pruner ',
          :environment => 'PATH=/bin:/usr/bin:/usr/sbin',
          :user        => 'glance',
          :minute      => '*/30',
          :hour        => '*',
          :monthday    => '*',
          :month       => '*',
          :weekday     => '*'
        )
        is_expected.to contain_cron('glance-cache-pruner').that_requires(
          'Anchor[glance::config::end]'
        )
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :minute           => 59,
          :hour             => 23,
          :monthday         => '1',
          :month            => '2',
          :weekday          => '3',
          :command_options  => '--config-dir /etc/glance/',
          :maxdelay         => 3600,
        }
      end
      it 'configures a cron' do
        is_expected.to contain_cron('glance-cache-pruner').with(
          :ensure      => :present,
          :command     => 'sleep `expr ${RANDOM} \\% 3600`; glance-cache-pruner --config-dir /etc/glance/',
          :environment => 'PATH=/bin:/usr/bin:/usr/sbin',
          :user        => 'glance',
          :minute      => 59,
          :hour        => 23,
          :monthday    => '1',
          :month       => '2',
          :weekday     => '3'
        )
      end
    end

    context 'when ensure is set to absent' do
      let :params do
        {
          :ensure => :absent
        }
      end
      it { should contain_cron('glance-cache-pruner').with_ensure(:absent) }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glance cache pruner'
    end
  end
end
