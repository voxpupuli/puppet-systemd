# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Match' do
  context 'with a key of What can have thing to link' do
    it { is_expected.to allow_value({ 'Driver' => 'brcmsmac' }) }
  end
end
