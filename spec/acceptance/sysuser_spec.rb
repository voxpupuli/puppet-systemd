# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'systemd::sysuser' do
  context 'with a valid sysuser entry' do
    let(:manifest) do
      <<~PUPPET
        systemd::sysuser{ 'plato.conf':
          content => 'u plato - "Be kind"',
        }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(manifest, catch_failures: true)
      apply_manifest(manifest, catch_changes: true)
    end

    describe file('/etc/sysusers.d/plato.conf') do
      it { is_expected.to be_file }
    end

    describe user('plato') do
      it { is_expected.to exist }
    end
  end

  context 'with an invalid sysuser entry' do
    let(:manifest) do
      <<~PUPPET
        systemd::sysuser{ 'aristotle.conf':
          content => 'total rubbish',
        }
      PUPPET
    end

    it 'applies with failures (as expected)' do
      skip 'old OSes have no --dry-run option' if
          ((fact('os.name') == 'Debian') && (fact('os.release.major') == '11')) ||
          ((fact('os.name') == 'Ubuntu') && (fact('os.release.major') == '22.04')) ||
          ((fact('os.family') == 'RedHat') && (fact('os.release.major') == '8'))

      res = apply_manifest(manifest, expect_failures: true)
      expect(res.stderr + res.stdout).to match(%r{Unknown modifier})
    end

    describe file('/etc/sysusers.d/aristotle.conf') do
      skip 'old OSes have no --dry-run option' if
          ((fact('os.name') == 'Debian') && (fact('os.release.major') == '11')) ||
          ((fact('os.name') == 'Ubuntu') && (fact('os.release.major') == '22.04')) ||
          ((fact('os.family') == 'RedHat') && (fact('os.release.major') == '8'))

      it { is_expected.not_to be_file }
    end
  end
end
