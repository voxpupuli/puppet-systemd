# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Timer' do
  # permitted durations and as arrays as well
  %w[OnActiveSec OnBootSec OnStartUpSec OnUnitActiveSec OnUnitInactiveSec].each do |assert|
    context "with a key of #{assert} can have values of units" do
      it { is_expected.to allow_value({ assert => '' }) }
      it { is_expected.to allow_value({ assert => 10 }) }
      it { is_expected.to allow_value({ assert => '5min' }) }
      it { is_expected.to allow_value({ assert => ['', 5, '50s', '5h 30min'] }) }
    end
  end

  %w[OnCalendar].each do |assert|
    context "with a key of #{assert} can have values of units" do
      it { is_expected.to allow_value({ assert => '' }) }
      it { is_expected.to allow_value({ assert => '24hours' }) }
      it { is_expected.to allow_value({ assert => 'daily' }) }
      it { is_expected.to allow_value({ assert => '1min 30s' }) }
      it { is_expected.to allow_value({ assert => ['', 'daily', '1min 30s'] }) }
    end
  end

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
