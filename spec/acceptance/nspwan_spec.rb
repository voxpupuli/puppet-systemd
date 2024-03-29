# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd with manage_nspawn true' do
  machinectl = (fact('os.name') == 'Debian') && %w[10 11].include?(fact('os.release.major')) ? '/bin/machinectl' : '/usr/bin/machinectl'

  context 'configure nspawn' do
    let(:manifest) do
      <<~PUPPET
        class { 'systemd':
          manage_nspawn => true,
        }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(manifest, catch_failures: true)
      apply_manifest(manifest, catch_changes: true)
    end

    describe file(machinectl) do
      it { is_expected.to be_file }
    end
  end
end
