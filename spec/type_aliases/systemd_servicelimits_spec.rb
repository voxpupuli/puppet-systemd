# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::ServiceLimits' do
  it { is_expected.to allow_value({ 'LimitMEMLOCK' => '100:100K' }) }

  it { is_expected.to allow_value({ 'MemoryAccounting' => true }) }

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

  it { is_expected.not_to allow_value({ 'MemoryHigh' => '1P' }) }
end
