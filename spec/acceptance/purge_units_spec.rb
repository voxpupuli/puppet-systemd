# frozen_string_literal: true

require 'spec_helper_acceptance'

SERVICE_FILE = '/etc/systemd/system/purgetest.service'
TIMER_FILE   = '/etc/systemd/system/purgetest.timer'
FOREIGN_FILE = '/etc/systemd/system/foreign.service'

describe 'systemd::purge_units' do
  # Deploys two units (a service and a timer) with systemd::manage_unit.
  let(:manage_manifest) do
    <<~PUPPET
      systemd::manage_unit { 'purgetest.service':
        unit_entry    => { 'Description' => 'Purge test service' },
        service_entry => { 'Type' => 'oneshot', 'ExecStart' => '/bin/true' },
        install_entry => { 'WantedBy' => 'multi-user.target' },
      }

      systemd::manage_unit { 'purgetest.timer':
        unit_entry    => { 'Description' => 'Purge test timer' },
        timer_entry   => { 'OnCalendar' => 'daily' },
        install_entry => { 'WantedBy' => 'timers.target' },
      }
    PUPPET
  end

  context 'when previously managed units are removed from the catalog' do
    # The manage_unit resources have been removed and purging is enabled instead.
    let(:purge_manifest) do
      <<~PUPPET
        class { 'systemd':
          purge_units => true,
        }
      PUPPET
    end

    context 'after deploying the units' do
      it 'is idempotent and leaves a hand-written unit in place' do
        # A hand-written unit file with no puppet header. It must never be purged.
        create_remote_file(default, FOREIGN_FILE, "[Unit]\nDescription=not deployed with puppet\n")
        apply_manifest(manage_manifest, catch_failures: true)
        apply_manifest(manage_manifest, catch_changes: true)
      end

      describe file(SERVICE_FILE) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(%r{\A# Deployed with puppet}) }
      end

      describe file(TIMER_FILE) do
        it { is_expected.to be_file }
      end
    end

    context 'after the units are purged' do
      it 'is idempotent' do
        apply_manifest(purge_manifest, catch_failures: true)
        apply_manifest(purge_manifest, catch_changes: true)
      end

      describe file(SERVICE_FILE) do
        it('the purged service no longer exists') { is_expected.not_to exist }
      end

      describe file(TIMER_FILE) do
        it('the purged timer no longer exists') { is_expected.not_to exist }
      end

      describe file(FOREIGN_FILE) do
        it { is_expected.to be_file }
      end
    end
  end

  context 'when restricting the unit types to purge' do
    # Only purge services, leaving timers in place.
    let(:restricted_manifest) do
      <<~PUPPET
        class { 'systemd::purge_units':
          unit_types => ['service'],
        }
      PUPPET
    end

    it 'redeploys the units then purges only services, idempotently' do
      apply_manifest(manage_manifest, catch_failures: true)
      apply_manifest(restricted_manifest, catch_failures: true)
      apply_manifest(restricted_manifest, catch_changes: true)
    end

    describe file(SERVICE_FILE) do
      it { is_expected.not_to exist }
    end

    describe file(TIMER_FILE) do
      it { is_expected.to be_file }
    end
  end
end
