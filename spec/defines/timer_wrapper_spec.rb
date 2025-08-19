# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::timer_wrapper' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'timer_name' }

        context 'simple usage' do
          let :params do
            {
              ensure: 'present',
              on_calendar: '*:0/10',
              command: '/bin/date',
              user: 'root',
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file("/etc/systemd/system/#{title}.service").
              with_content(%r{# Deployed with puppet}).
              with_content(%r{Type=oneshot}).
              with_content(%r{ExecStart=/bin/date}).
              with_content(%r{Type=oneshot}).
              with_content(%r{User=root})
            is_expected.to contain_file("/etc/systemd/system/#{title}.timer").
              with_content(%r{OnCalendar=\*:0/10}).
              with_content(%r{WantedBy=timers.target})
            is_expected.to contain_Systemd__Unit_file("#{title}.service").
              that_comes_before("Systemd::Unit_file[#{title}.timer]")
            is_expected.to contain_Systemd__Unit_file("#{title}.service").
              that_comes_before("Systemd::Unit_file[#{title}.timer]")
            is_expected.to contain_Exec("systemd-#{title}.service-systemctl-daemon-reload")
            is_expected.to contain_Exec("systemd-#{title}.timer-systemctl-daemon-reload")
            is_expected.to contain_Service("#{title}.timer")
            is_expected.to contain_Systemd__Daemon_reload("#{title}.service")
            is_expected.to contain_Systemd__Daemon_reload("#{title}.timer")
            is_expected.to contain_Systemd__Manage_unit("#{title}.service")
            is_expected.to contain_Systemd__Manage_unit("#{title}.timer")
            is_expected.to contain_Systemd__Unit_file("#{title}.timer")
          end
        end

        context 'failue when not passing calendar spec' do
          let :params do
            {
              ensure: 'present',
              command: '/bin/date',
              user: 'root',
            }
          end

          it do
            is_expected.to compile.and_raise_error(%r{At least one of on_active_sec})
          end
        end

        context 'with / in title' do
          let :title do
            't/i/t/l/e'
          end
          let :params do
            {
              ensure: 'present',
              on_calendar: '*:0/10',
              command: '/bin/true',
              user: 'root',
            }
          end

          it {
            is_expected.to compile.and_raise_error(%r{expects a match for Systemd::Unit = Pattern})
          }
        end

        context 'ensure absent' do
          let :params do
            {
              ensure: 'absent',
            }
          end

          it {
            is_expected.to contain_Systemd__Manage_unit("#{title}.timer").
              with_ensure('absent')
            is_expected.to contain_Systemd__Manage_unit("#{title}.service").
              with_ensure('absent')
            is_expected.to contain_Service("#{title}.timer").
              that_comes_before("Systemd::Unit_file[#{title}.timer]").
              with_ensure(false)
            is_expected.to contain_Systemd__Unit_file("#{title}.timer").
              that_comes_before("Systemd::Unit_file[#{title}.service]").
              with_ensure('absent')
          }
        end

        context 'applies service_overrides' do
          let :params do
            {
              ensure: 'present',
              command: 'date',
              service_overrides: { 'Group' => 'bob' },
              on_boot_sec: 100,
              user: 'root',
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.service").
              with_content(%r{Group=bob})
          }
        end

        context 'applies service_unit_overrides' do
          let :params do
            {
              ensure: 'present',
              command: 'date',
              service_unit_overrides: { 'Wants' => 'network-online.target' },
              on_boot_sec: 100,
              user: 'root',
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.service").
              with_content(%r{Wants=network-online.target})
          }
        end

        context 'applies timer_overrides' do
          let :params do
            {
              ensure: 'present',
              command: 'date',
              timer_overrides: { 'OnBootSec' => '200' },
              on_boot_sec: 100,
              user: 'root',
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.timer").
              with_content(%r{OnBootSec=200})
          }
        end

        context 'applies timer_unit_overrides' do
          let :params do
            {
              ensure: 'present',
              command: 'date',
              timer_unit_overrides: { 'Wants' => 'network-online.target' },
              on_boot_sec: 100,
              user: 'root',
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.timer").
              with_content(%r{Wants=network-online.target})
          }
        end

        context 'applies pre_command' do
          let :params do
            {
              ensure: 'present',
              pre_command: '/usr/bin/date',
              command: 'date',
              user: 'root',
              on_boot_sec: 100,
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.service").
              with_content(%r{ExecStartPre=/usr/bin/date})
          }
        end

        context 'applies post_command' do
          let :params do
            {
              ensure: 'present',
              command: 'date',
              post_command: '/usr/bin/date',
              user: 'root',
              on_boot_sec: 100,
            }
          end

          it {
            is_expected.to contain_file("/etc/systemd/system/#{title}.service").
              with_content(%r{ExecStartPost=/usr/bin/date})
          }
        end
      end
    end
  end
end
