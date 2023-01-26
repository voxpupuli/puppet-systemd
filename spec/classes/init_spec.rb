# frozen_string_literal: true

require 'spec_helper'

describe 'systemd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('systemd') }
        it { is_expected.to contain_class('systemd::journald') }
        it { is_expected.to create_service('systemd-journald') }
        it { is_expected.to have_ini_setting_resource_count(0) }
        it { is_expected.not_to contain_class('systemd::machine_info') }
        it { is_expected.not_to create_service('systemd-resolved') }
        it { is_expected.not_to create_service('systemd-networkd') }
        it { is_expected.not_to create_service('systemd-timesyncd') }
        it { is_expected.not_to contain_package('systemd-timesyncd') }
        it { is_expected.not_to contain_package('systemd-resolved') }
        it { is_expected.not_to contain_class('systemd::coredump') }
        it { is_expected.not_to contain_class('systemd::oomd') }
        it { is_expected.not_to contain_exec('systemctl set-default multi-user.target') }

        context 'when enabling resolved and networkd' do
          let(:params) do
            {
              manage_resolved: true,
              manage_networkd: true,
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.to contain_file('/etc/resolv.conf').with_ensure('symlink') }
          it { is_expected.not_to contain_exec('restore_resolv.conf_if_possible') }
          it { is_expected.to create_service('systemd-networkd').with_ensure('running') }
          it { is_expected.to create_service('systemd-networkd').with_enable(true) }
          it { is_expected.not_to contain_file('/etc/systemd/network') }

          case [facts[:os]['family'], facts[:os]['release']['major']]
          when %w[RedHat 7], %w[RedHat 9]
            it { is_expected.to contain_package('systemd-resolved') }
          else
            it { is_expected.not_to contain_package('systemd-resolved') }
          end
          context 'with manage_resolv_conf false' do
            let(:params) { super().merge(manage_resolv_conf: false) }

            it { is_expected.not_to contain_file('/etc/resolv.conf') }
          end

          context 'with manage_resolv_conf true' do
            let(:params) { super().merge(manage_resolv_conf: true) }

            it { is_expected.to contain_file('/etc/resolv.conf') }
          end
        end

        context 'when resolved_ensure is stopped' do
          let(:params) do
            {
              manage_resolved: true,
              resolved_ensure: 'stopped',
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('stopped') }
          it { is_expected.to create_service('systemd-resolved').with_enable(false) }
          it { is_expected.not_to contain_file('/etc/resolv.conf') }
          it { is_expected.to contain_exec('restore_resolv.conf_if_possible') }

          context 'with manage_resolv_conf false' do
            let(:params) { super().merge(manage_resolv_conf: false) }

            it { is_expected.not_to contain_file('/etc/resolv.conf') }
            it { is_expected.not_to contain_exec('restore_resolv.conf_if_possible') }
          end

          context 'with manage_resolv_conf true' do
            let(:params) { super().merge(manage_resolv_conf: true) }

            it { is_expected.not_to contain_file('/etc/resolv.conf') }
            it { is_expected.to contain_exec('restore_resolv.conf_if_possible') }
          end
        end

        context 'when enabling resolved with DNS values (string)' do
          let(:params) do
            {
              manage_resolved: true,
              dns: '8.8.8.8 8.8.4.4',
              fallback_dns: '2001:4860:4860::8888 2001:4860:4860::8844',
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.to contain_ini_setting('dns') }
          it { is_expected.to contain_ini_setting('fallback_dns') }
          it { is_expected.not_to contain_ini_setting('domains') }
          it { is_expected.not_to contain_ini_setting('multicast_dns') }
          it { is_expected.not_to contain_ini_setting('llmnr') }
          it { is_expected.not_to contain_ini_setting('dnssec') }
          it { is_expected.not_to contain_ini_setting('dnsovertls') }
          it { is_expected.not_to contain_ini_setting('cache') }
          it { is_expected.not_to contain_ini_setting('dns_stub_listener') }
        end

        context 'when enabling resolved with DNS values (array)' do
          let(:params) do
            {
              manage_resolved: true,
              dns: ['8.8.8.8', '8.8.4.4'],
              fallback_dns: ['2001:4860:4860::8888', '2001:4860:4860::8844'],
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.to contain_ini_setting('dns') }
          it { is_expected.to contain_ini_setting('fallback_dns') }
          it { is_expected.not_to contain_ini_setting('domains') }
          it { is_expected.not_to contain_ini_setting('multicast_dns') }
          it { is_expected.not_to contain_ini_setting('llmnr') }
          it { is_expected.not_to contain_ini_setting('dnssec') }
          it { is_expected.not_to contain_ini_setting('dnsovertls') }
          it { is_expected.not_to contain_ini_setting('cache') }
          it { is_expected.not_to contain_ini_setting('dns_stub_listener') }
        end

        context 'when enabling resolved with DNS values (full)' do
          let(:params) do
            {
              manage_resolved: true,
              dns: ['8.8.8.8', '8.8.4.4'],
              fallback_dns: ['2001:4860:4860::8888', '2001:4860:4860::8844'],
              domains: ['2001:4860:4860::8888', '2001:4860:4860::8844'],
              llmnr: true,
              multicast_dns: false,
              dnssec: false,
              dnsovertls: 'no',
              cache: true,
              dns_stub_listener: 'udp',
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.to contain_ini_setting('dns') }
          it { is_expected.to contain_ini_setting('fallback_dns') }
          it { is_expected.to contain_ini_setting('domains') }
          it { is_expected.to contain_ini_setting('multicast_dns') }
          it { is_expected.to contain_ini_setting('llmnr') }
          it { is_expected.to contain_ini_setting('dnssec') }
          it { is_expected.to contain_ini_setting('dnsovertls') }

          it {
            expect(subject).to contain_ini_setting('cache').with(
              path: '/etc/systemd/resolved.conf',
              value: 'yes'
            )
          }

          it { is_expected.to contain_ini_setting('dns_stub_listener') }
        end

        context 'when enabling resolved with no-negative cache variant' do
          let(:params) do
            {
              manage_resolved: true,
              cache: 'no-negative',
            }
          end

          it { is_expected.to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.to create_service('systemd-resolved').with_enable(true) }

          it {
            expect(subject).to contain_ini_setting('cache').with(
              path: '/etc/systemd/resolved.conf',
              value: 'no-negative'
            )
          }
        end

        context 'with alternate target' do
          let(:params) do
            {
              default_target: 'example.target',
            }
          end

          it { is_expected.to contain_exec('systemctl set-default example.target') }
          it { is_expected.to contain_service('example.target').with_enable(true).with_ensure('running') }
        end

        context 'when enabling oomd without settings' do
          let(:params) do
            {
              manage_oomd: true,
            }
          end

          it { is_expected.to create_service('systemd-oomd').with_ensure('running') }
          it { is_expected.to create_service('systemd-oomd').with_enable(true) }
        end

        context 'when enabling oomd with settings' do
          let(:params) do
            {
              manage_oomd: true,
              oomd_settings: {
                'SwapUsedLimit' => '10‰',
                'DefaultMemoryPressureLimit' => '10%',
                'DefaultMemoryPressureDurationSec' => 10,
              },
            }
          end

          it { is_expected.to create_service('systemd-oomd').with_ensure('running') }
          it { is_expected.to create_service('systemd-oomd').with_enable(true) }
          it { is_expected.to have_ini_setting_resource_count(3) }

          it {
            expect(subject).to contain_ini_setting('SwapUsedLimit').with(
              path: '/etc/systemd/oomd.conf',
              section: 'OOM',
              notify: 'Service[systemd-oomd]',
              value: '10‰'
            )
          }

          it {
            expect(subject).to contain_ini_setting('DefaultMemoryPressureLimit').with(
              path: '/etc/systemd/oomd.conf',
              section: 'OOM',
              notify: 'Service[systemd-oomd]',
              value: '10%'
            )
          }

          it {
            expect(subject).to contain_ini_setting('DefaultMemoryPressureDurationSec').with(
              path: '/etc/systemd/oomd.conf',
              section: 'OOM',
              notify: 'Service[systemd-oomd]',
              value: 10
            )
          }
        end

        context 'when enabling timesyncd' do
          let(:params) do
            {
              manage_timesyncd: true,
            }
          end

          it { is_expected.to create_service('systemd-timesyncd').with_ensure('running') }
          it { is_expected.to create_service('systemd-timesyncd').with_enable(true) }
          it { is_expected.not_to create_service('systemd-resolved').with_ensure('running') }
          it { is_expected.not_to create_service('systemd-resolved').with_enable(true) }
          it { is_expected.not_to create_service('systemd-networkd').with_ensure('running') }
          it { is_expected.not_to create_service('systemd-networkd').with_enable(true) }

          if (facts[:os]['name'] == 'Ubuntu' && Puppet::Util::Package.versioncmp(facts[:os]['release']['full'], '20.04') >= 0) || (facts[:os]['name'] == 'Debian' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '11') >= 0)
            it { is_expected.to contain_package('systemd-timesyncd') }
          else
            it { is_expected.not_to contain_package('systemd-timesyncd') }
          end
        end

        context 'when enabling timesyncd with NTP values (string)' do
          let(:params) do
            {
              manage_timesyncd: true,
              ntp_server: '0.pool.ntp.org 1.pool.ntp.org',
              fallback_ntp_server: '2.pool.ntp.org 3.pool.ntp.org',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_ini_setting('ntp_server') }
          it { is_expected.to contain_ini_setting('fallback_ntp_server') }
        end

        context 'when enabling timesyncd with NTP values (array)' do
          let(:params) do
            {
              manage_timesyncd: true,
              ntp_server: ['0.pool.ntp.org', '1.pool.ntp.org'],
              fallback_ntp_server: ['2.pool.ntp.org', '3.pool.ntp.org'],
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_ini_setting('ntp_server') }
          it { is_expected.to contain_ini_setting('fallback_ntp_server') }
        end

        context 'when passing service limits' do
          let(:params) do
            {
              service_limits: { 'openstack-nova-compute.service' => { 'limits' => { 'LimitNOFILE' => 32_768 } } },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__service_limits('openstack-nova-compute.service').with_limits('LimitNOFILE' => 32_768) }
        end

        context 'when passing networks' do
          let :params do
            {
              networks: { 'uplink.network' => { 'content' => 'foo' }, 'uplink.netdev' => { 'content' => 'bar' }, },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__network('uplink.network').with_content('foo') }
          it { is_expected.to contain_systemd__network('uplink.netdev').with_content('bar') }
          it { is_expected.to contain_file('/etc/systemd/network/uplink.network') }
          it { is_expected.to contain_file('/etc/systemd/network/uplink.netdev') }
          it { is_expected.to have_systemd__network_resource_count(2) }
        end

        context 'when passing timers' do
          let :params do
            {
              timers: { 'first.timer' => { 'timer_content' => 'foo' }, 'second.timer' => { 'timer_content' => 'bar' }, },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__timer('first.timer').with_timer_content('foo') }
          it { is_expected.to contain_systemd__timer('second.timer').with_timer_content('bar') }
          it { is_expected.to contain_systemd__unit_file('first.timer').with_content('foo') }
          it { is_expected.to contain_systemd__unit_file('second.timer').with_content('bar') }
          it { is_expected.to contain_file('/etc/systemd/system/first.timer') }
          it { is_expected.to contain_file('/etc/systemd/system/second.timer') }
          it { is_expected.to have_systemd__timer_resource_count(2) }
          it { is_expected.to have_systemd__unit_file_resource_count(2) }
        end

        context 'when passing tmpfiles' do
          let :params do
            {
              tmpfiles: { 'first_tmpfile.conf' => { 'content' => 'foo' }, 'second_tmpfile.conf' => { 'content' => 'bar' }, },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__tmpfile('first_tmpfile.conf').with_content('foo') }
          it { is_expected.to contain_systemd__tmpfile('second_tmpfile.conf').with_content('bar') }
          it { is_expected.to contain_file('/etc/tmpfiles.d/first_tmpfile.conf') }
          it { is_expected.to contain_file('/etc/tmpfiles.d/second_tmpfile.conf') }
          it { is_expected.to have_systemd__tmpfile_resource_count(2) }
        end

        context 'when passing unit_files' do
          let :params do
            {
              unit_files: { 'first.service' => { 'content' => 'foo' }, 'second.service' => { 'content' => 'bar' }, },
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__unit_file('first.service').with_content('foo') }
          it { is_expected.to contain_systemd__unit_file('second.service').with_content('bar') }
          it { is_expected.to contain_file('/etc/systemd/system/first.service') }
          it { is_expected.to contain_file('/etc/systemd/system/second.service') }
          it { is_expected.to have_systemd__unit_file_resource_count(2) }
        end

        context 'when managing Accounting options' do
          let :params do
            {
              manage_accounting: true,
            }
          end

          it { is_expected.to contain_class('systemd::system') }

          case facts[:os]['family']
          when 'Archlinux', 'Gentoo'
            accounting = %w[DefaultCPUAccounting DefaultIOAccounting DefaultIPAccounting DefaultBlockIOAccounting DefaultMemoryAccounting DefaultTasksAccounting]
          when 'Debian'
            accounting = %w[DefaultCPUAccounting DefaultBlockIOAccounting DefaultMemoryAccounting]
          when 'RedHat', 'Suse'
            accounting = %w[DefaultCPUAccounting DefaultBlockIOAccounting DefaultMemoryAccounting DefaultTasksAccounting]
          end
          accounting.each do |account|
            it { is_expected.to contain_ini_setting(account) }
          end
          it { is_expected.to compile.with_all_deps }
        end

        context 'when enabling journald with options' do
          let(:params) do
            {
              manage_journald: true,
              journald_settings: {
                'Storage' => 'auto',
                'MaxRetentionSec' => '5day',
                'MaxLevelStore' => {
                  'ensure' => 'absent',
                },
              },
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).to contain_service('systemd-journald').with(
              ensure: 'running'
            )
          }

          it { is_expected.to have_ini_setting_resource_count(3) }

          it {
            expect(subject).to contain_ini_setting('Storage').with(
              path: '/etc/systemd/journald.conf',
              section: 'Journal',
              notify: 'Service[systemd-journald]',
              value: 'auto'
            )
          }

          it {
            expect(subject).to contain_ini_setting('MaxRetentionSec').with(
              path: '/etc/systemd/journald.conf',
              section: 'Journal',
              notify: 'Service[systemd-journald]',
              value: '5day'
            )
          }

          it {
            expect(subject).to contain_ini_setting('MaxLevelStore').with(
              path: '/etc/systemd/journald.conf',
              section: 'Journal',
              notify: 'Service[systemd-journald]',
              ensure: 'absent'
            )
          }
        end

        context 'when disabling journald' do
          let(:params) do
            {
              manage_journald: false,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_service('systemd-journald') }
        end

        context 'when disabling udevd management' do
          let(:params) do
            {
              manage_udevd: false,
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_service('systemd-udevd') }
          it { is_expected.not_to contain_file('/etc/udev/udev.conf') }
        end

        context 'when working with udevd and no custom rules' do
          let(:params) do
            {
              manage_udevd: true,
              udev_log: 'daemon',
              udev_children_max: 1,
              udev_exec_delay: 2,
              udev_event_timeout: 3,
              udev_resolve_names: 'early',
              udev_timeout_signal: 'SIGKILL',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).to contain_service('systemd-udevd').
              with(enable: true,
                   ensure: 'running')
          }

          it {
            expect(subject).to contain_file('/etc/udev/udev.conf').
              with(ensure: 'file',
                   owner: 'root',
                   group: 'root',
                   mode: '0444').
              with_content(%r{^udev_log=daemon$}).
              with_content(%r{^children_max=1$}).
              with_content(%r{^exec_delay=2$}).
              with_content(%r{^event_timeout=3$}).
              with_content(%r{^resolve_names=early$}).
              with_content(%r{^timeout_signal=SIGKILL$})
          }
        end

        context 'when working with udevd and a rule set' do
          let(:params) do
            {
              manage_udevd: true,
              udev_log: 'daemon',
              udev_children_max: 1,
              udev_exec_delay: 2,
              udev_event_timeout: 3,
              udev_resolve_names: 'early',
              udev_timeout_signal: 'SIGKILL',
              udev_rules: { 'example_raw.rules' => {
                'rules' => [
                  '# I am a comment',
                  'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                  'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
                ],
              } },

            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).to contain_service('systemd-udevd').
              with(enable: true,
                   ensure: 'running')
          }

          it {
            expect(subject).to contain_file('/etc/udev/udev.conf').
              with(ensure: 'file',
                   owner: 'root',
                   group: 'root',
                   mode: '0444').
              with_content(%r{^udev_log=daemon$}).
              with_content(%r{^children_max=1$}).
              with_content(%r{^exec_delay=2$}).
              with_content(%r{^event_timeout=3$}).
              with_content(%r{^resolve_names=early$}).
              with_content(%r{^timeout_signal=SIGKILL$})
          }

          it {
            expect(subject).to contain_systemd__udev__rule('example_raw.rules').
              with(rules: [
                     '# I am a comment',
                     'ACTION=="add", KERNEL=="sda", RUN+="/bin/raw /dev/raw/raw1 %N"',
                     'ACTION=="add", KERNEL=="sdb", RUN+="/bin/raw /dev/raw/raw2 %N"',
                   ])
          }
        end

        context 'with machine-info' do
          let(:params) do
            {
              machine_info_settings: {
                'PRETTY_HOSTNAME' => 'example hostname',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_shellvar('PRETTY_HOSTNAME').with(value: 'example hostname') }
        end

        context 'when enabling logind with options' do
          let(:params) do
            {
              manage_logind: true,
              logind_settings: {
                'HandleSuspendKey' => 'ignore',
                'KillUserProcesses' => 'no',
                'KillExcludeUsers' => %w[a b],
                'RemoveIPC' => {
                  'ensure' => 'absent',
                },
                'UserTasksMax' => '10000',
              },
              loginctl_users: {
                'foo' => { 'linger' => 'enabled' },
              },
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).to contain_service('systemd-logind').with(
              ensure: 'running'
            )
          }

          it { is_expected.to have_ini_setting_resource_count(5) }

          it {
            expect(subject).to contain_ini_setting('HandleSuspendKey').with(
              path: '/etc/systemd/logind.conf',
              section: 'Login',
              notify: 'Service[systemd-logind]',
              value: 'ignore'
            )
          }

          it {
            expect(subject).to contain_ini_setting('KillUserProcesses').with(
              path: '/etc/systemd/logind.conf',
              section: 'Login',
              notify: 'Service[systemd-logind]',
              value: 'no'
            )
          }

          it {
            expect(subject).to contain_ini_setting('KillExcludeUsers').with(
              path: '/etc/systemd/logind.conf',
              section: 'Login',
              notify: 'Service[systemd-logind]',
              value: 'a b'
            )
          }

          it {
            expect(subject).to contain_ini_setting('RemoveIPC').with(
              path: '/etc/systemd/logind.conf',
              section: 'Login',
              notify: 'Service[systemd-logind]',
              ensure: 'absent'
            )
          }

          it {
            expect(subject).to contain_ini_setting('UserTasksMax').with(
              path: '/etc/systemd/logind.conf',
              section: 'Login',
              notify: 'Service[systemd-logind]',
              value: '10000'
            )
          }

          it { is_expected.to contain_loginctl_user('foo').with(linger: 'enabled') }
        end

        context 'when passing dropin_files' do
          let(:params) do
            {
              dropin_files: {
                'my-foo.conf' => {
                  'unit' => 'foo.service',
                  'content' => '[Service]\nReadWritePaths=/',
                },
              },
            }
          end

          it { is_expected.to contain_systemd__dropin_file('my-foo.conf').with_content('[Service]\nReadWritePaths=/') }
        end

        context 'with managed networkd directory' do
          let :params do
            {
              manage_networkd: true,
              manage_all_network_files: true
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('systemd::networkd') }
          it { is_expected.to contain_file('/etc/systemd/network').with_ensure('directory') }
        end

        context 'when not managing systemd-coredump' do
          let :params do
            {
              manage_coredump: false,
              coredump_settings: { 'Storage' => 'none' },
            }
          end

          it { is_expected.not_to contain_class('systemd::coredump') }
        end

        context 'when managing systemd-coredump' do
          let :params do
            {
              manage_coredump: true,
              coredump_settings: {
                'Storage' => 'none',
                'ProcessSizeMax' => '5000E',
                'Compress' => 'yes',
              }
            }
          end

          it { is_expected.to contain_class('systemd::coredump') }
          it { is_expected.to contain_systemd__dropin_file('coredump_backtrace.conf').with_ensure('absent') }

          it { is_expected.to contain_ini_setting('coredump_Storage') }

          it {
            is_expected.to contain_ini_setting('coredump_Storage').with(
              {
                path: '/etc/systemd/coredump.conf',
                section: 'Coredump',
                setting: 'Storage',
                value: 'none',
              }
            )
          }

          it {
            is_expected.to contain_ini_setting('coredump_ProcessSizeMax').with(
              {
                path: '/etc/systemd/coredump.conf',
                section: 'Coredump',
                setting: 'ProcessSizeMax',
                value: '5000E',
              }
            )
          }

          it {
            is_expected.to contain_ini_setting('coredump_Compress').with(
              {
                path: '/etc/systemd/coredump.conf',
                section: 'Coredump',
                setting: 'Compress',
                value: 'yes',
              }
            )
          }

          context 'with backtrace false' do
            let :params do
              super().merge({ coredump_backtrace: false })
            end

            it { is_expected.to contain_systemd__dropin_file('coredump_backtrace.conf').with_ensure('absent') }
          end

          context 'with coredump_sysctl_manage true and backtrace true' do
            let :params do
              super().merge({ coredump_backtrace: true })
            end

            it { is_expected.to contain_systemd__dropin_file('coredump_backtrace.conf').with_ensure('file') }
            it { is_expected.to contain_systemd__dropin_file('coredump_backtrace.conf').with_content(%r{^ExecStart=.*--backtrace$}) }
          end
        end
      end
    end
  end
end
