# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::ServiceLimits' do
  it { is_expected.to allow_value({ 'MemoryAccounting' => true }) }

  it {
    is_expected.to allow_value(
      {
        'MemoryMin' => '10%',
        'MemoryHigh' => '8G',
        'MemoryMax' => 'infinity'
      }
    )
  }

  it { is_expected.not_to allow_value({ 'MemoryHigh' => '1P' }) }
end
