# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Socket' do
  %w[ListenStream ListenDatagram ListenSequentialPacket].each do |assert|
    context "with a key of #{assert} can have values of a path" do
      it { is_expected.to allow_value({ assert => 200 }) }
      it { is_expected.to allow_value({ assert => '/etc/passwd' }) }
      it { is_expected.to allow_value({ assert => '@/tmp/socket' }) }
    end
  end

  %w[ListenMessageQueue].each do |assert|
    context "with a key of #{assert} can have values of a queue" do
      it { is_expected.to allow_value({ assert => '/mything' }) }
      it { is_expected.not_to allow_value({ assert => 'mything' }) }
    end
  end

  context 'with a key of OOMScoreAdjust' do
    it {
      is_expected.to allow_value({ 'OOMScoreAdjust' => 999 })
      is_expected.to allow_value({ 'OOMScoreAdjust' => -999 })
      is_expected.not_to allow_value({ 'OOMScoreAdjust' => 1005 })
      is_expected.not_to allow_value({ 'OOMScoreAdjust' => '10' })
    }
  end
end
