require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "systemd" do
    context 'returns true when systemd present' do
      before do
        Facter.fact(:kernel).stubs(:value).returns(:linux)
      end
      let(:facts) { {:kernel => :linux} }
      it do
        expect(Facter.value(:initsystem)).to eq(:systemd)
        expect(Facter.value(:systemd)).to eq(true)
      end
    end
      context 'returns false when systemd not present' do
        before do
          Facter.fact(:kernel).stubs(:value).returns(:linux)
        end
        let(:facts) { {:kernel => :linux} }
        it do
          expect(Facter.value(:initsystem)).not_to eq(:systemd)
          expect(Facter.value(:systemd)).to eq(false)
        end
    end

    context 'returns nil when kernel is not linux' do
      before do
        Facter.fact(:kernel).stubs(:value).returns(:windows)
      end
      let(:facts) { {:kernel => :windows} }
      it do
        expect(Facter.value(:initsystem)).to be_nil
        expect(Facter.value(:systemd)).to be_nil
      end
    end
  end
end
