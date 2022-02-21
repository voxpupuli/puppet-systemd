# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd' do
  context 'configure systemd resolved' do
    it 'works idempotently with no errors' do
      pp = <<-PUPPET
      class{'systemd':
        manage_resolved    => true,
        manage_resolv_conf => #{default[:hypervisor] != 'docker'},
      }
      PUPPET
      apply_manifest(pp, catch_failures: true)
      # RedHat 9 and newer installs package first run before fact  $facts['internal_services'] is set
      apply_manifest(pp, catch_failures: true) if Gem::Version.new(fact('os.release.major')) >= Gem::Version.new('9') && (fact('os.family') == 'RedHat')
      apply_manifest(pp, catch_changes: true)
    end

    # RedHat 7 does not have systemd-resolved available at all.
    describe service('systemd-resolved'), unless: (fact('os.release.major') == '7' and fact('os.family') == 'RedHat') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
