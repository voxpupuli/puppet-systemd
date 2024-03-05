# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Amount' do
  it { is_expected.to allow_value(100) }
  it { is_expected.to allow_value('200') }
  it { is_expected.to allow_value('8G') }
  it { is_expected.to allow_value('1T') }
  it { is_expected.to allow_value('infinity') }

  it { is_expected.not_to allow_value('1P') }
  it { is_expected.not_to allow_value('10%') }
end
