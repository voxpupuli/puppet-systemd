# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Service' do
  %w[ExecStart ExecStartPre ExecStartPost ExecCondition ExecReload ExecStop ExecStopPost].each do |depend|
    context "with a key of #{depend} can have values of commands" do
      it { is_expected.to allow_value({ depend.to_s => '/usr/bin/doit.sh' }) }
      it { is_expected.to allow_value({ depend.to_s => ['/usr/bin/doit.sh'] }) }
      it { is_expected.to allow_value({ depend.to_s => ['-/usr/bin/doit.sh', ':/doit.sh', '+/doit.sh', '!/doit.sh', '!!/doit.sh'] }) }
      it { is_expected.to allow_value({ depend.to_s => '' }) }
      it { is_expected.to allow_value({ depend.to_s => [''] }) }
      it { is_expected.to allow_value({ depend.to_s => ['', '/doit.sh'] }) }
    end
  end

  it { is_expected.to allow_value({ 'ExecStart' => 'notabsolute.sh' }) }
  it { is_expected.not_to allow_value({ 'ExecStart' => '*/wrongprefix.sh' }) }

  it { is_expected.to allow_value({ 'EnvironmentFile' => '/etc/sysconfig/foo' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => '-/etc/sysconfig/foo' }) }
  it { is_expected.not_to allow_value({ 'EnvironmentFile' => 'relative-path.sh' }) }
end
