# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::purge_units' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_systemd_purge_units('/etc/systemd/system').with_unit_types(%w[automount mount path service slice socket swap timer]) }
      it { is_expected.to contain_systemd__daemon_reload('purge_units') }

      context 'with custom unit_types' do
        let(:params) do
          {
            unit_types: %w[service timer],
          }
        end

        it { is_expected.to contain_systemd_purge_units('/etc/systemd/system').with_unit_types(%w[service timer]) }
      end

      context 'with custom paths' do
        let(:params) do
          {
            paths: ['/path1', '/path2'],
          }
        end

        it { is_expected.to contain_systemd_purge_units('/path1').that_notifies('Systemd::Daemon_reload[purge_units]') }
        it { is_expected.to contain_systemd_purge_units('/path2').that_notifies('Systemd::Daemon_reload[purge_units]') }

        it { is_expected.to have_systemd_purge_units_resource_count(2) }
      end

      context 'with `daemon_reload` false' do
        let(:params) do
          {
            daemon_reload: false,
          }
        end

        it { is_expected.to contain_systemd_purge_units('/etc/systemd/system') }
        it { is_expected.not_to contain_systemd__daemon_reload('purge_units') }
      end
    end
  end
end
