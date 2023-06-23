# frozen_string_literal: true

require 'spec_helper'

describe 'Systemd::Unit::Service' do
  %w[ExecStart ExecStartPre ExecStartPost ExecCondition ExecReload ExecStop ExecStopPost].each do |depend|
    context "with a key of #{depend} can have values of commands" do
      it { is_expected.to allow_value({ depend => '/usr/bin/doit.sh' }) }
      it { is_expected.to allow_value({ depend => ['/usr/bin/doit.sh'] }) }
      it { is_expected.to allow_value({ depend => ['-/usr/bin/doit.sh', ':/doit.sh', '+/doit.sh', '!/doit.sh', '!!/doit.sh'] }) }
      it { is_expected.to allow_value({ depend => '' }) }
      it { is_expected.to allow_value({ depend => [''] }) }
      it { is_expected.to allow_value({ depend => ['', '/doit.sh'] }) }
    end
  end

  %w[SyslogIdentifier].each do |depend|
    context "with a key of #{depend} can have values of strings" do
      it { is_expected.to allow_value({ depend => 'simple' }) }
      it { is_expected.not_to allow_value({ depend => ['', 'simple'] }) }
    end
  end

  it { is_expected.to allow_value({ 'KillMode' => 'mixed' }) }
  it { is_expected.not_to allow_value({ 'KillMode' => 'wrong' }) }

  it { is_expected.to allow_value({ 'KillSignal' => 'SIGTERM' }) }
  it { is_expected.not_to allow_value({ 'KillSignal' => 'SIGterm' }) }
  it { is_expected.not_to allow_value({ 'KillSignal' => 9 }) }
  it { is_expected.to allow_value({ 'LimitCORE' => 'infinity' }) }
  it { is_expected.to allow_value({ 'LimitCORE' => '100M' }) }
  it { is_expected.not_to allow_value({ 'LimitCORE' => 'random string' }) }

  it { is_expected.to allow_value({ 'ExecStart' => 'notabsolute.sh' }) }
  it { is_expected.not_to allow_value({ 'ExecStart' => '*/wrongprefix.sh' }) }

  it { is_expected.to allow_value({ 'EnvironmentFile' => '/etc/sysconfig/foo' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => '-/etc/sysconfig/foo' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => ['/etc/sysconfig/foo', '-/etc/sysconfig/foo-bar'] }) }
  it { is_expected.not_to allow_value({ 'EnvironmentFile' => '-/' }) }
  it { is_expected.not_to allow_value({ 'EnvironmentFile' => 'relative-path.sh' }) }

  it { is_expected.to allow_value({ 'User' => 'root' }) }
  it { is_expected.to allow_value({ 'Group' => 'root' }) }
  it { is_expected.to allow_value({ 'StandardOutput' => 'null' }) }
  it { is_expected.to allow_value({ 'StandardError' => 'null' }) }

  it { is_expected.to allow_value({ 'WorkingDirectory' => '/var/lib/here' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '-/var/lib/here' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '~' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '' }) }

  it { is_expected.to allow_value({ 'LogLevelMax' => 'alert' }) }
  it { is_expected.not_to allow_value({ 'LogLevelMax' => 'top' }) }
end
