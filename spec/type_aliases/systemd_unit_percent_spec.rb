# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Percent' do
  it { is_expected.to allow_value('1%') }
  it { is_expected.to allow_value('100%') }

  it { is_expected.not_to allow_value(1) }
  it { is_expected.not_to allow_value('105%') }
end
