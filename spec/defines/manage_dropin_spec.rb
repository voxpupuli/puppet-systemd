# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::manage_dropin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'foobar.conf' }

        context 'drop file chaning Type and resetting ExecStart' do
          let(:params) do
            {
              unit: 'special.service',
              service_entry: {
                Type:      'oneshot',
                ExecStart: ['', '/usr/bin/doit.sh'],
              },
            }
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
      end
    end
  end
end
