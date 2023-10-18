# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd with manage_networkd true' do
  has_package = fact('os.family') == 'RedHat'

  # On Enterprise Linux 8 & 9 the package is shipped in EPEL
  before { install_package(default, 'epel-release') if has_package && %w[8 9].include?(fact('os.release.major')) }

  context 'configure systemd-networkd' do
    let(:manifest) do
      <<~PUPPET
        class { 'systemd':
          manage_networkd => true,
        }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(manifest, catch_failures: true)
      # Package systemd-networkd needs to be installed before fact $facts['internal_services'] is set
      apply_manifest(manifest, catch_failures: true) if has_package
      apply_manifest(manifest, catch_changes: true)
    end

    describe service('systemd-networkd') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    it { expect(package('systemd-networkd')).to be_installed } if has_package
  end

  context 'configure systemd stopped' do
    let(:manifest) do
      <<~PUPPET
        class { 'systemd':
          manage_networkd => true,
          networkd_ensure => 'stopped',
        }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(manifest, catch_failures: true)
      apply_manifest(manifest, catch_changes: true)
    end

    describe service('systemd-networkd') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
