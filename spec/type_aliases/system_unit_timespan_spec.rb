# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Timespan' do
  context 'with a permitted value' do
    # permitted durations and as arrays as well
    [
      '',
      10,
      '5m',
      'daily',
      '5h 30min',
      '24hours',
      ['', 5, '50s', '5h 30min']
    ].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
end
