# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::daemon_reload' do
  # Mirrors the command array returned by systemd::systemctl_user
  def systemctl_user(user, *args)
    ['runuser', '-u', user, '--', '/usr/bin/bash', '-c',
     "env XDG_RUNTIME_DIR=/run/user/$(id -u) /usr/bin/systemctl --user #{args.join(' ')}",]
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'irregardless' }

        it { is_expected.to compile.with_all_deps }

        context 'with defaults' do
          it do
            expect(subject).to contain_exec("systemd-#{title}-systemctl-daemon-reload")
              .with_command(%w[systemctl daemon-reload])
              .with_refreshonly(true)
          end

          context 'with a username specified' do
            let(:params) do
              { user: 'steve' }
            end

            case [facts[:os]['family'], facts[:os]['release']['major']]
            when %w[RedHat 8]
              it { is_expected.to compile.and_raise_error(%r{user is not supported below}) }
            else
              it { is_expected.to compile }

              it {
                is_expected.to contain_exec('systemd-irregardless-systemctl-user-steve-daemon-reload')
                  .with_command(systemctl_user('steve', 'daemon-reload'))
                  .with_refreshonly(true)
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

          context 'with a username specified' do
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
