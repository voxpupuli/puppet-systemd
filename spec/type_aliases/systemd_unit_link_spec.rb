# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Link' do
  context 'with a key of What can have thing to link' do
    it { is_expected.to allow_value({ 'MTUBytes' => 1024 }) }
  end
end
