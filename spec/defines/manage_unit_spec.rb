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
        end
      end
    end
  end
end
