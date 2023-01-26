# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::MachineInfoSettings' do
  it { is_expected.to allow_value({ 'PRETTY_HOSTNAME' => 'example' }) }
  it { is_expected.to allow_value({ 'ICON_NAME' => 'computer' }) }
  it { is_expected.to allow_value({ 'CHASSIS' => 'server' }) }
  it { is_expected.to allow_value({ 'DEPLOYMENT' => 'production' }) }
  it { is_expected.to allow_value({ 'LOCATION' => 'Home' }) }
  it { is_expected.to allow_value({ 'HARDWARE_VENDOR' => 'fake vendor' }) }
  it { is_expected.to allow_value({ 'HARDWARE_MODEL' => 'fake model' }) }

  it { is_expected.not_to allow_value({ 'PRETTY_HOSTNAME' => '' }) }
end
