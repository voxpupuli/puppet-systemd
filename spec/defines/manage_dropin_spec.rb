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
            it { is_expected.to contain_systemd__dropin_file('foobar.conf') }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^\[Service\]$})
            }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                without_content(%r{^\[Unit\]$})
            }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                without_content(%r{^\[Install\]$})
            }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^ExecStart=$})
            }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^ExecStart=/usr/bin/doit.sh$})
            }

            it {
              is_expected.to contain_systemd__dropin_file('foobar.conf').
                with_content(%r{^Type=oneshot$})
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
      end
    end
  end
end
