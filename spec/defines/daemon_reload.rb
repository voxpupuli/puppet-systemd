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
      end
    end
  end
end
