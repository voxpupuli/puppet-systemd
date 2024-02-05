# frozen_string_literal: true

require 'spec_helper'

describe Facter.fact(:loginctl_linger_users) do
  before do
    Facter.clear
  end

  describe 'loginctl_linger_users' do
    context 'returns root when nothing is present' do
      it do
        allow(Dir).to receive(:exist?).and_return(false)
        allow(Dir).to receive(:exist?).with('/var/lib/systemd/linger').and_return(false)

        expect(Facter.value(:loginctl_linger_users)).to eq(['root'])
      end
    end

    context 'returns list with root others are present' do
      it do
        allow(Dir).to receive(:exist?).and_return(false)
        allow(Dir).to receive(:exist?).with('/var/lib/systemd/linger').and_return(true)
        allow(Dir).to receive(:entries).with('/var/lib/systemd/linger').and_return(%w[. .. abc test])

        expect(Facter.value(:loginctl_linger_users)).to eq(%w[abc test root])
      end
    end
  end
end
