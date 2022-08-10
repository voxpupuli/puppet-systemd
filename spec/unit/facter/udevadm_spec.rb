# frozen_string_literal: true

require 'spec_helper'

describe 'udevadm fact', type: :fact do
  subject(:fact) { Facter.fact(:udevadm) }

  before do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return(kernel)
  end

  context 'when kernel is Linux' do
    let(:kernel) { 'Linux' }

    context 'when udevadm is present' do
      before do
        allow(Facter::Core::Execution).to receive(:which).with('udevadm').and_return('/foo')
        allow(Facter::Core::Execution).to receive(:exec).with('/foo --version').and_return('249')
      end

      it do
        expect(fact.value).to include(
          'path'    => '/foo',
          'version' => '249'
        )
      end
    end

    context 'when udevadm is not present' do
      before do
        allow(Facter::Core::Execution).to receive(:which).with('udevadm').and_return(nil)
      end

      it { expect(fact.value).to be_nil }
    end
  end

  context 'when kernel is not Linux' do
    let(:kernel) { 'Windows' }

    it { expect(fact.value).to be_nil }
  end
end
