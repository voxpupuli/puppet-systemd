# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'foobar.conf' }

        context 'on a service' do
          let(:params) do
            {
              unit: 'special.service',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__dropin_file('foobar.conf').with_content(%r{^# Deployed with puppet$}) }

          context 'with empty sections' do
            let(:params) do
              super().merge(
                unit_entry: {},
                service_entry: {}
              )
            end

            it { is_expected.to compile.with_all_deps }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^\[Unit\]$}).
                with_content(%r{^\[Service\]$}).
                without_content(%r{^\[Slice\]$})
            }
          end

          context 'setting some parameters simply' do
            let(:params) do
              super().merge(
                unit_entry: {
                  DefaultDependencies: true
                },
                service_entry: {
                  SyslogIdentifier: 'simple',
                  LimitCORE: 'infinity',
                  IODeviceWeight:
                    [
                      ['/dev/weight', 10],
                      ['/dev/weight2', 20],
                    ],
                  IOReadBandwidthMax: ['/dev/weight3', '50K'],
                }
              )
            end

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^LimitCORE=infinity$}).
                with_content(%r{^DefaultDependencies=true$}).
                with_content(%r{^SyslogIdentifier=simple$}).
                with_content(%r{^IODeviceWeight=/dev/weight 10$}).
                with_content(%r{^IODeviceWeight=/dev/weight2 20$}).
                with_content(%r{^IOReadBandwidthMax=/dev/weight3 50K$}).
                without_content(%r{^\[Slice\]$})
            }
          end

          context 'drop file chaning Type and resetting ExecStart' do
            let(:params) do
              super().merge(
                service_entry: {
                  Type:      'oneshot',
                  ExecStart: ['', '/usr/bin/doit.sh'],
                }
              )
            end

            it { is_expected.to compile.with_all_deps }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^\[Service\]$}).
                without_content(%r{^\[Unit\]$}).
                without_content(%r{^\[Install\]$}).
                with_content(%r{^ExecStart=$}).
                with_content(%r{^ExecStart=/usr/bin/doit.sh$}).
                with_content(%r{^Type=oneshot$})
            }
          end

          context 'with an instance to instance relation' do
            let(:params) do
              super().merge(
                unit_entry: {
                  'After'    => ['user-runtime-dir@%i.service'],
                  'Requires' => ['user-runtime-dir@%i.service'],
                }
              )
            end

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^After=user-runtime-dir@%i.service$}).
                with_content(%r{^Requires=user-runtime-dir@%i.service$})
            }
          end

          context 'with a timer entry' do
            let(:params) do
              super().merge(
                timer_entry: {
                  'OnCalendar' => 'soon',
                }
              )
            end

            it { is_expected.to compile.and_raise_error(%r{timer_entry is only valid for timer units}) }
          end

          context 'with a slice entry' do
            let(:params) do
              super().merge(
                slice_entry: {
                  'MemoryMax' => '100G',
                }
              )
            end

            it { is_expected.to compile.and_raise_error(%r{slice_entry is only valid for slice units}) }
          end
        end

        context 'on a swap unit' do
          let(:params) do
            {
              unit: 'file.swap',
              swap_entry: {
                'Priority' => 10,
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('file.swap').
              with_content(%r{^\[Swap\]$}).
              with_content(%r{^Priority=10$})
          }
        end

        context 'on a timer' do
          let(:params) do
            {
              unit: 'special.timer',
              timer_entry: {
                'OnCalendar' => 'soon',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('special.timer').
              with_content(%r{^OnCalendar=soon$})
          }
        end

        context 'on a mount' do
          let(:params) do
            {
              unit: 'var-lib-sss-db.mount',
              mount_entry: {
                'SloppyOptions' => true,
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('var-lib-sss-db.mount').
              with_content(%r{^SloppyOptions=true$})
          }
        end

        context 'on a slice' do
          let(:params) do
            {
              unit: 'user-.slice',
              slice_entry: {
                'MemoryMax' => '10G',
                'MemoryAccounting' => true,
                'IOWriteBandwidthMax' => [
                  ['/dev/afs', '50P'],
                  ['/dev/gluster', 50],
                ]
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('user-.slice').
              with_content(%r{^IOWriteBandwidthMax=/dev/afs 50P$}).
              with_content(%r{^IOWriteBandwidthMax=/dev/gluster 50$}).
              with_content(%r{^MemoryMax=10G$}).
              with_content(%r{^MemoryAccounting=true$}).
              without_content(%r{^\[Service\]$})
          }
        end

        context 'on a path unit' do
          let(:params) do
            {
              unit: 'special.path',
              path_entry: {
                'PathExists' => '/etc/hosts',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('special.path').
              with_content(%r{^\[Path\]$}).
              with_content(%r{^PathExists=/etc/hosts$})
          }
        end

        context 'on a socket unit' do
          let(:params) do
            {
              unit: 'special.socket',
              socket_entry: {
                'ListenMessageQueue' => '/panic',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__dropin_file('foobar.conf').
              with_unit('special.socket').
              with_content(%r{^\[Socket\]$}).
              with_content(%r{^ListenMessageQueue=/panic$})
          }
        end
      end
    end
  end
end
