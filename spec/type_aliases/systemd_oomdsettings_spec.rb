# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::OomdSettings' do
  it {
    is_expected.to allow_value(
      {
        'SwapUsedLimit' => '100%',
        'DefaultMemoryPressureLimit' => '0%',
        'DefaultMemoryPressureDurationSec' => 0,
      }
    )
  }

  it {
    is_expected.to allow_value(
      {
        'SwapUsedLimit' => '1‰',
        'DefaultMemoryPressureLimit' => '100%',
        'DefaultMemoryPressureDurationSec' => 100_000_000,
      }
    )
  }

  it {
    is_expected.to allow_value(
      {
        'SwapUsedLimit' => '90‱',
        'DefaultMemoryPressureLimit' => '30%',
        'DefaultMemoryPressureDurationSec' => 10,
      }
    )
  }

  it { is_expected.not_to allow_value({ 'SwapUsedLimit' => '60' }) }
  it { is_expected.not_to allow_value({ 'SwapUsedLimit' => '%' }) }
  it { is_expected.not_to allow_value({ 'DefaultMemoryPressureLimit' => '10' }) }
  it { is_expected.not_to allow_value({ 'DefaultMemoryPressureDurationSec' => -10 }) }
end
