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
          it { is_expected.to contain_systemd__unit_file('foobar.service') }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^\[Unit\]$})
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^\[Service\]$})
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^\[Install\]$})
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^Description=My great service$})
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
              with_content(%r{^Description=has two lines of description$})
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').
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
                'OnCalendar' => 'soon',
              }
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__unit_file('winter.timer').
              with_content(%r{^OnCalendar=soon$})
          }
        end
      end
    end
  end
end
