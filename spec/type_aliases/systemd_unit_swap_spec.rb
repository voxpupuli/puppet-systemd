# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Swap' do
  context 'with a key of What can have thing to mount' do
    it { is_expected.to allow_value({ 'What' => '/tmpfs' }) }
    it { is_expected.to allow_value({ 'What' => '/dev/vda1' }) }
  end

  context 'with a key of Options' do
    it { is_expected.to allow_value({ 'Options' => 'trim' }) }
  end

  context 'with a key of Priority' do
    it { is_expected.to allow_value({ 'Priority' => 10 }) }
  end

  context 'with a key of TimeoutSec can have a mode of' do
    it { is_expected.to allow_value({ 'TimeoutSec' => '100' }) }
    it { is_expected.to allow_value({ 'TimeoutSec' => '5min 20s' }) }
    it { is_expected.to allow_value({ 'TimeoutSec' => '' }) }
  end

  context 'with a key of Where' do
    it { is_expected.not_to allow_value({ 'Where' => '/mnt/foo' }) }
  end
end
