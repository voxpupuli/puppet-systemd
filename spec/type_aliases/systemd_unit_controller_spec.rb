# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Controller' do
  %w[
    cpu
    cpuset
    io
    memory
    pids
    bpf-firewall
    bpf-devices
    bpf-foreign
    bpf-socket-bind
    bpf-restrict-network-interfaces
    bpf-bind-network-interface
  ].each do |controller|
    it { is_expected.to allow_value(controller) }
  end

  it { is_expected.not_to allow_value('') }
  it { is_expected.not_to allow_value('CPU') }
  it { is_expected.not_to allow_value('not-a-controller') }
  it { is_expected.not_to allow_value('cpu memory') }
end
