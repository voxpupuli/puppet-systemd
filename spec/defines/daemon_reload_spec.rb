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
              with_command(%w[systemctl daemon-reload]).
              with_refreshonly(true).
              without_environment.
              without_user
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

        context 'when a non-zero uid is specified' do
          let(:params) do
            { 'uid' => 1234 }
          end

          it do
            expect(subject).to contain_exec("systemd-#{title}-systemctl-user-1234-daemon-reload").
              with_command(%w[systemctl --user daemon-reload]).
              with_environment('XDG_RUNTIME_DIR=/run/user/1234').
              with_user(1234).
              with_refreshonly(true)
          end
        end

        context 'when the uid is 0 (root)' do
          let(:params) do
            { 'uid' => 0 }
          end

          it { is_expected.to compile.and_raise_error(%r{Undef or Integer\[1\]}) }
        end
      end
    end
  end
end
