# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::user_service' do
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
            is_expected.to contain_exec('Enable user service mine.timer globally').
              with_command(['systemctl', '--global', 'enable', 'mine.timer']).
              with_unless([['systemctl', '--global', 'is-enabled', 'mine.timer']]).
              without_onlyif
          }
        end

        context 'with global disable' do
          let(:params) do
            { global: true, enable: false }
          end

          it {
            is_expected.to contain_exec('Disable user service mine.timer globally').
              with_command(['systemctl', '--global', 'disable', 'mine.timer']).
              without_unless.
              with_onlyif([['systemctl', '--global', 'is-enabled', 'mine.timer']])
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
              is_expected.to contain_exec('Stop user service mine.timer for user steve').
                with_command([
                               'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                               'systemctl', '--user', 'stop', 'mine.timer',
                             ]).
                with_onlyif([[
                              'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                              'systemctl', '--user', 'is-active', 'mine.timer',
                            ]]).
                without_unless
            }

            it {
              is_expected.to contain_exec('Disable user service mine.timer for user steve').
                with_command([
                               'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                               'systemctl', '--user', 'disable', 'mine.timer',
                             ]).
                with_onlyif([[
                              'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                              'systemctl', '--user', 'is-enabled', 'mine.timer',
                            ]]).
                without_unless
            }
          end

          context 'with enable and ensure true' do
            let(:params) do
              super().merge(enable: true, ensure: 'running')
            end

            it {
              is_expected.to contain_exec('Start user service mine.timer for user steve').
                with_command([
                               'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                               'systemctl', '--user', 'start', 'mine.timer',
                             ]).
                without_onlyif.
                with_unless([[
                              'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                              'systemctl', '--user', 'is-active', 'mine.timer',
                            ]])
            }

            it {
              is_expected.to contain_exec('Enable user service mine.timer for user steve').
                with_command([
                               'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                               'systemctl', '--user', 'enable', 'mine.timer',
                             ]).
                without_onlif.
                with_unless([[
                              'systemd-run', '--pipe', '--wait', '--user', '--machine', 'steve@.host',
                              'systemctl', '--user', 'is-enabled', 'mine.timer',
                            ]])
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
        end
      end
    end
  end
end
