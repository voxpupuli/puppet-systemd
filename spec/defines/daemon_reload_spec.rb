# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::daemon_reload' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts.merge(systemd_version: '256') }
        let(:title) { 'irregardless' }

        it { is_expected.to compile.with_all_deps }

        context 'with defaults' do
          it do
            expect(subject).to contain_exec("systemd-#{title}-systemctl-daemon-reload").
              with_command(%w[systemctl daemon-reload]).
              with_refreshonly(true)
          end

          context 'with a username specfied' do
            let(:params) do
              { user: 'steve' }
            end

            case [facts[:os]['name'], facts[:os]['family'], facts[:os]['release']['major']]
            when %w[Debian Debian 11],
              ['Ubuntu', 'Debian', '20.04'],
              %w[AlmaLinux RedHat 8],
              %w[RedHat RedHat 8],
              %w[Rocky RedHat 8],
              %w[OracleLinux RedHat 8]
              it { is_expected.to compile.and_raise_error(%r{user is not supported below}) }
            else
              it { is_expected.to compile }

              it {
                is_expected.to contain_exec('systemd-irregardless-systemctl-user-steve-daemon-reload').
                  with_command(['run0', '--user', 'steve', '/usr/bin/systemctl', '--user', 'daemon-reload']).
                  with_refreshonly(true)
              }

            end
          end
        end

        context 'when disabled' do
          let(:params) do
            { 'enable' => false }
          end

          it do
            expect(subject).not_to contain_exec("systemd-#{title}-systemctl-daemon-reload")
          end

          context 'with a username specfied' do
            let(:params) do
              super().merge(user: 'steve')
            end

            it { is_expected.not_to contain_exec('systemd-irregardless-systemctl-user-steve-daemon-reload') }
          end
        end
      end
    end
  end
end
