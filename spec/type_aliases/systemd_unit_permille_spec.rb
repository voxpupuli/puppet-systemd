# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Permille' do
  it { is_expected.to allow_value('1‰') }
  it { is_expected.to allow_value('500‰') }
  it { is_expected.to allow_value('1000‰') }

  it { is_expected.not_to allow_value(1) }
  it { is_expected.not_to allow_value('0‰') }
  it { is_expected.not_to allow_value('1001‰') }
  it { is_expected.not_to allow_value('50%') }
  it { is_expected.not_to allow_value('50‱') }
end
