# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::daemon_reload' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'irregardless' }

        it { is_expected.to compile.with_all_deps }

        context 'with defaults' do
          it do
            expect(subject).to contain_exec("systemd-#{title}-systemctl-daemon-reload").
              with_command('systemctl daemon-reload').
              with_refreshonly(true)

            expect(subject).not_to contain_exec("systemd-#{title}-global-systemctl-daemon-check")
          end
        end

        context 'when disabled' do
          let(:params) do
            { 'enable' => false }
          end

          it do
            expect(subject).not_to contain_exec("systemd-#{title}-systemctl-daemon-reload")
          end
        end

        context 'with lazy reloading' do
          let(:pre_condition) { 'service { "test": }' }
          let(:params) do
            { 'lazy_reload' => true }
          end

          it do
            expect(subject).to contain_exec("systemd-#{title}-systemctl-daemon-reload").
              with_command('systemctl daemon-reload').
              with_refreshonly(true)

            expect(subject).to contain_exec("systemd-#{title}-global-systemctl-daemon-check").
              with_command('systemctl daemon-reload').
              with_onlyif('systemctl show "*" --property=NeedDaemonReload | grep -qxFm1 "NeedDaemonReload=yes"').
              that_comes_before('Service[test]')
          end
        end
      end
    end
  end
end
