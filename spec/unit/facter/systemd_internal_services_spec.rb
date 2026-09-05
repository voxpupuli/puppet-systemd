# frozen_string_literal: true

require 'spec_helper'

describe Facter.fact(:systemd_internal_services) do
  before do
    Facter.clear
  end

  describe 'systemd_internal_services' do
    context 'when systemd fact is present' do
      before do
        allow(Facter.fact(:systemd)).to receive(:value).and_return(true)
      end

      let(:facts) { { systemd: true } }

      it 'includes masked services in the state filter and parses service states' do
        allow(Facter::Core::Execution).to receive(:execute).with(
          'systemctl list-unit-files --no-legend --no-pager "systemd-*" -t service --state=enabled,disabled,enabled-runtime,indirect,masked',
        ).and_return(<<~OUTPUT)
          systemd-networkd.service enabled
          systemd-resolved.service disabled
          systemd-journal-remote.service indirect
          systemd-some-internal.service masked
        OUTPUT

        expect(Facter.value(:systemd_internal_services)).to eq(
          {
            'systemd-networkd.service' => 'enabled',
            'systemd-resolved.service' => 'disabled',
            'systemd-journal-remote.service' => 'indirect',
            'systemd-some-internal.service' => 'masked',
          },
        )
      end
    end

    context 'when systemd fact is not present' do
      before do
        allow(Facter.fact(:systemd)).to receive(:value).and_return(false)
      end

      let(:facts) { { systemd: false } }

      it 'returns nil and does not execute systemctl' do
        expect(Facter::Core::Execution).not_to receive(:execute)
        expect(Facter.value(:systemd_internal_services)).to be_nil
      end
    end
  end
end
