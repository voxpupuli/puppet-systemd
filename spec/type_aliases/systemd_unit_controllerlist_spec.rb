# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::ControllerList' do
  it { is_expected.to allow_value('cpu') }
  it { is_expected.to allow_value('cpu memory') }
  it { is_expected.to allow_value("cpu\tmemory") }
  it { is_expected.to allow_value('cpu   memory') }
  it { is_expected.to allow_value(%w[cpu memory pids]) }
  it { is_expected.to allow_value(['cpu']) }

  it { is_expected.not_to allow_value('') }
  it { is_expected.not_to allow_value(' cpu') }
  it { is_expected.not_to allow_value('cpu ') }
  it { is_expected.not_to allow_value('cpu nope') }
  it { is_expected.not_to allow_value('cpu,memory') }
  it { is_expected.not_to allow_value(%w[cpu nope]) }
  it { is_expected.not_to allow_value(['cpu memory']) }
  it { is_expected.not_to allow_value(true) }
end
