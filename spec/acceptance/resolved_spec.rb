# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd with manage_resolved true' do
  context 'configure systemd resolved' do
    it 'works idempotently with no errors' do
      pp = <<-PUPPET
      class{'systemd':
        manage_resolved    => true,
        manage_resolv_conf => #{default[:hypervisor] != 'docker'},
      }
      PUPPET
      apply_manifest(pp, catch_failures: true)
      # RedHat 7, 9 and newer installs package first run before fact $facts['internal_services'] is set
      apply_manifest(pp, catch_failures: true) if fact('os.release.major') != '8' && (fact('os.family') == 'RedHat')
      apply_manifest(pp, catch_changes: true)
    end

    describe service('systemd-resolved') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'configure systemd stopped' do
    it 'works idempotently with no errors' do
      pp = <<-PUPPET
      class{'systemd':
        manage_resolved    => true,
        resolved_ensure    => 'stopped',
        manage_resolv_conf => #{default[:hypervisor] != 'docker'},
      }
      PUPPET
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('systemd-resolved') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
