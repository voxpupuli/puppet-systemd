require 'spec_helper_acceptance'

describe 'systemd' do

  context 'with defaults' do
    it 'should run successfully and idempotently' do
      pp = <<-EOS
        class { 'systemd': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  ['resolved', 'networkd', 'timesyncd', 'accounting'].each do |srv|
    context "when managing service #{srv}" do
      it 'should run successfully and idempotently' do
        pp = <<-EOS
          class { 'systemd':
            manage_#{srv}   => true,
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end
    end
  end
end
