# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Slice' do
  it { is_expected.to allow_value({ 'MemoryAccounting' => true }) }
  it { is_expected.to allow_value({ 'CPUWeight' => 100 }) }
  it { is_expected.to allow_value({ 'CPUQuota' => '1%' }) }
  it { is_expected.to allow_value({ 'CPUQuota' => '110%' }) }
  it { is_expected.to allow_value({ 'CPUWeight' => 'idle' }) }
  it { is_expected.to allow_value({ 'IPAccounting' => true }) }
  it { is_expected.to allow_value({ 'IOAccounting' => false }) }
  it { is_expected.to allow_value({ 'IOWeight' => 100 }) }

  it { is_expected.to allow_value({ 'DeviceAllow' => '/dev/sda1' }) }
  it { is_expected.to allow_value({ 'DeviceAllow' => 'block-loop' }) }
  it { is_expected.not_to allow_value({ 'DeviceAllow' => 'random' }) }

  it {
    is_expected.to allow_value(
      {
        'MemoryLow' => '100',
        'MemoryMin' => '10%',
        'MemoryHigh' => '8G',
        'MemoryMax' => 'infinity',
        'MemorySwapMax' => '1T',
      }
    )
  }

  it { is_expected.not_to allow_value({ 'CPUQuota' => 50 }) }
  it { is_expected.not_to allow_value({ 'CPUQuota' => '0%' }) }
  it { is_expected.not_to allow_value({ 'MemoryHigh' => '1Y' }) }
end
