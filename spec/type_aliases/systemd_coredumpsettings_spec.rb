# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::CoredumpSettings' do
  it { is_expected.to allow_value({ 'Storage' => 'none' }) }

  it {
    is_expected.to allow_value(
      {
        'Storage' => 'external',
        'Compress' => 'yes',
        'ProcessSizeMax' => '123K',
        'ExternalSizeMax' => '456G',
        'JournalSizeMax' => '45T',
        'MaxUse' => '1P',
        'MaxFree' => '1E',
      }
    )
  }

  it {
    is_expected.to allow_value(
      {
        'Storage' => 'journal',
        'Compress' => 'no',
        'ProcessSizeMax' => '123',
        'ExternalSizeMax' => '456',
        'JournalSizeMax' => '45',
        'MaxUse' => '1',
        'MaxFree' => '5',
      }
    )
  }

  it { is_expected.not_to allow_value({ 'Storage' => 'big' }) }
  it { is_expected.not_to allow_value({ 'Compress' => 'maybe' }) }
  it { is_expected.not_to allow_value({ 'MaxUse' => '-10' }) }
  it { is_expected.not_to allow_value({ 'MaxFee' => '10Gig' }) }
  it { is_expected.not_to allow_value({ 'ProcessSizeMax' => '20g' }) }
  it { is_expected.not_to allow_value({ 'JournalSizeMax' => '20Z' }) }
end
