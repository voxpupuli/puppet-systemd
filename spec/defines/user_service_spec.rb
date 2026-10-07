# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::user_service' do
  # Mirrors the command array returned by systemd::systemctl_user
  def systemctl_user(user, *args)
    ['runuser', '-u', user, '--', '/usr/bin/bash', '-c',
     "env XDG_RUNTIME_DIR=/run/user/$(id -u) /usr/bin/systemctl --user #{args.join(' ')}",]
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'mine.timer' }

        context 'with defaults' do
          it { is_expected.to compile.and_raise_error(%r{"user" or "global"}) }
        end

        context 'with user and global set' do
          let(:params) do
            { global: true, user: 'steve' }
          end

          it { is_expected.to compile.and_raise_error(%r{"user" or "global"}) }
        end

        context 'with global and ensure' do
          let(:params) do
            { global: true, ensure: 'running' }
          end

          it { is_expected.to compile.and_raise_error(%r{Cannot ensure a service is running for all users globally}) }
        end

        context 'with global enable' do
          let(:params) do
            { global: true, enable: true }
          end

          it {
            is_expected.to contain_exec('Enable user service mine.timer globally')
          }

          it {
            is_expected.to contain_exec('Enable user service mine.timer globally')
              .with_command(['systemctl', '--global', 'enable', 'mine.timer'])
              .with_unless([['systemctl', '--global', 'is-enabled', 'mine.timer']])
              .without_onlyif
          }
        end

        context 'with global disable' do
          let(:params) do
            { global: true, enable: false }
          end

          it {
            is_expected.to contain_exec('Disable user service mine.timer globally')
              .with_command(['systemctl', '--global', 'disable', 'mine.timer'])
              .without_unless
              .with_onlyif([['systemctl', '--global', 'is-enabled', 'mine.timer']])
          }
        end

        context 'with global mask' do
          let(:params) do
            { global: true, enable: 'mask' }
          end

          it {
            is_expected.to contain_exec('Mask user service mine.timer globally')
              .with_command(['systemctl', '--global', 'mask', 'mine.timer'])
              .with_unless('test "$(systemctl --global is-enabled mine.timer)" = masked')
              .without_onlyif
          }
        end

        context 'with a user specified' do
          let(:params) do
            { user: 'steve' }
          end

          it { is_expected.to contain_exec('try-reload-or-restart-steve-mine.timer') }

          context 'with enable and ensure false' do
            let(:params) do
              super().merge(enable: false, ensure: 'stopped')
            end

            it {
              is_expected.to contain_exec('Stop user service mine.timer for user steve')
                .with_command(systemctl_user('steve', 'stop', 'mine.timer'))
                .with_onlyif([systemctl_user('steve', 'is-active', 'mine.timer')])
                .without_unless
            }

            it {
              is_expected.to contain_exec('Disable user service mine.timer for user steve')
                .with_command(systemctl_user('steve', 'disable', 'mine.timer'))
                .with_onlyif([systemctl_user('steve', 'is-enabled', 'mine.timer')])
                .without_unless
            }
          end

          context 'with enable and ensure true' do
            let(:params) do
              super().merge(enable: true, ensure: 'running')
            end

            it {
              is_expected.to contain_exec('Start user service mine.timer for user steve')
                .with_command(systemctl_user('steve', 'start', 'mine.timer'))
                .without_onlyif
                .with_unless([systemctl_user('steve', 'is-active', 'mine.timer')])
            }

            it {
              is_expected.to contain_exec('Enable user service mine.timer for user steve')
                .with_command(systemctl_user('steve', 'enable', 'mine.timer'))
                .without_onlyif
                .with_unless([systemctl_user('steve', 'is-enabled', 'mine.timer')])
            }
          end

          context 'with enable true and ensure false' do
            let(:params) do
              super().merge(enable: true, ensure: false)
            end

            it { is_expected.to contain_exec('Stop user service mine.timer for user steve') }
            it { is_expected.to contain_exec('Enable user service mine.timer for user steve') }
          end

          context 'with enable false and ensure true' do
            let(:params) do
              super().merge(enable: false, ensure: true)
            end

            it { is_expected.to contain_exec('Start user service mine.timer for user steve') }
            it { is_expected.to contain_exec('Disable user service mine.timer for user steve') }
          end

          context 'with enable mask' do
            let(:params) do
              super().merge(enable: 'mask')
            end

            it {
              is_expected.to contain_exec('Mask user service mine.timer for user steve')
                .with_command(systemctl_user('steve', 'mask', 'mine.timer'))
                .with_unless(
                  [['/bin/sh', '-c', "test \"$(#{systemctl_user('steve', 'is-enabled', 'mine.timer').join(' ')})\" = masked"]],
                )
                .without_onlyif
            }
          end
        end
      end
    end
  end
end
