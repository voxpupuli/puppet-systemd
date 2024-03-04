# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Timer' do
  # permitted single values
  %w[AccuracySec RandomizedDelaySec].each do |assert|
    context "with a key of #{assert} can have values of units" do
      it { is_expected.to allow_value({ assert => '' }) }
      it { is_expected.to allow_value({ assert => 10 }) }
      it { is_expected.to allow_value({ assert => '24hours' }) }
      it { is_expected.to allow_value({ assert => '1min 30s' }) }
    end
  end

  # permitted booleans
  %w[FixedRandomDelay OnClockChange OnTimezoneChange Persistent RemainAfterElapse].each do |assert|
    context "with a key of #{assert} can have values of a time period" do
      it { is_expected.to allow_value({ assert => false }) }
      it { is_expected.to allow_value({ assert => true }) }
      it { is_expected.not_to allow_value({ assert => 'yes' }) }
    end
  end

  it { is_expected.to allow_value({ 'Unit' => 'my.service' }) }
  it { is_expected.not_to allow_value({ 'Unit' => 'my' }) }
end
