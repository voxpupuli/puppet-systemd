# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::manage_unit' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'foobar.service' }

        context 'with an arrayed description and simple parameters set' do
          let(:params) do
            {
              unit_entry: {
                Description: ['My great service', 'has two lines of description'],
                DefaultDependencies: true,
              },
              service_entry: {
                Type:      'oneshot',
                ExecStart: '/usr/bin/doit.sh',
              },
              install_entry: {
                WantedBy: 'multi-user.target',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^\[Unit\]$}).
              with_content(%r{^DefaultDependencies=true$}).
              with_content(%r{^\[Service\]$}).
              with_content(%r{^\[Install\]$}).
              with_content(%r{^Description=My great service$}).
              with_content(%r{^Description=has two lines of description$}).
              with_content(%r{^Type=oneshot$})
          }

          context 'with a timer entry' do
            let(:params) do
              super().merge(timer_entry: { 'OnCalendar' => 'something' })
            end

            it { is_expected.to compile.and_raise_error(%r{timer_entry is only valid for timer units}) }
          end
        end

        context 'on a timer' do
          let(:title) { 'winter.timer' }

          let(:params) do
            {
              unit_entry: {
                Description: 'Winter is coming',
              },
              timer_entry: {
                'OnActiveSec' => '5min',
                'OnBootSec' => ['', '1min 5s'],
                'OnStartUpSec' => 10,
                'OnUnitActiveSec' => '5s',
                'OnUnitInactiveSec' => ['', 10],
                'OnCalendar' => 'soon',
                'AccuracySec' => '24h',
                'RandomizedDelaySec' => '4min 20s',
                'FixedRandomDelay' => true,
                'OnClockChange' => false,
                'OnTimezoneChange' => true,
                'Unit' => 'summer.service',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__unit_file('winter.timer').
              with_content(%r{^\[Timer\]$}).
              with_content(%r{^OnActiveSec=5min$}).
              with_content(%r{^OnBootSec=$}).
              with_content(%r{^OnBootSec=1min 5s$}).
              with_content(%r{^OnStartUpSec=10$}).
              with_content(%r{^OnUnitActiveSec=5s$}).
              with_content(%r{^OnUnitInactiveSec=$}).
              with_content(%r{^OnUnitInactiveSec=10$}).
              with_content(%r{^OnCalendar=soon$}).
              with_content(%r{^AccuracySec=24h$}).
              with_content(%r{^RandomizedDelaySec=4min 20s$}).
              with_content(%r{^FixedRandomDelay=true$}).
              with_content(%r{^OnClockChange=false$}).
              with_content(%r{^OnTimezoneChange=true$}).
              with_content(%r{^Unit=summer.service$})
          }
        end
      end
    end
  end
end
