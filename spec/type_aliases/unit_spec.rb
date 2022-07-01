# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit' do
  context 'with a permitted unit name' do
    [
      'foo.service',
      'foo.socket',
      'atemplate@.service',
      'atemplate@instance.service',
      'backward\slash.swap',
      'extra.dot.scope',
      'a:colon.path',
      'an_underscore.device',
      'a-dash.slice',
    ].each do |unit|
      it { is_expected.to allow_value(unit.to_s) }
    end
  end

  context 'with a illegal unit name' do
    [
      'a space.service',
      'noending',
      'wrong.ending',
      'forward/slash.unit',
    ].each do |unit|
      it { is_expected.not_to allow_value(unit.to_s) }
    end
  end
end
