# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd with manage_resolved true' do
  has_package = (fact('os.family') == 'RedHat' && fact('os.release.major') != '8') || (fact('os.name') == 'Debian' && fact('os.release.major').to_i >= 12)

  context 'configure systemd resolved' do
    it 'works idempotently with no errors' do
      pp = <<-PUPPET
      class{'systemd':
        manage_resolved    => true,
        manage_resolv_conf => #{default[:hypervisor] != 'docker'},
      }
      PUPPET
      apply_manifest(pp, catch_failures: true)
      # RedHat 7, 9, Debian 12 and newer installs package first run before fact $facts['internal_services'] is set
      apply_manifest(pp, catch_failures: true) if has_package
      apply_manifest(pp, catch_changes: true)
    end

    describe service('systemd-resolved') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    it { expect(package('systemd-resolved')).to be_installed } if has_package
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
