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

  it { is_expected.to allow_value({ 'Environment' => '' }) }
  it { is_expected.to allow_value({ 'Environment' => 'FOO=BAR' }) }
  it { is_expected.to allow_value({ 'Environment' => ['FOO=BAR', 'BAR=FOO'] }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => '/etc/sysconfig/foo' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => '-/etc/sysconfig/foo' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => ['/etc/sysconfig/foo', '-/etc/sysconfig/foo-bar'] }) }
  it { is_expected.not_to allow_value({ 'EnvironmentFile' => '-/' }) }
  it { is_expected.not_to allow_value({ 'EnvironmentFile' => 'relative-path.sh' }) }

  it { is_expected.to allow_value({ 'User' => 'root' }) }
  it { is_expected.to allow_value({ 'Group' => 'root' }) }
  it { is_expected.to allow_value({ 'UMask' => '0022' }) }
  it { is_expected.to allow_value({ 'StandardOutput' => 'null' }) }
  it { is_expected.to allow_value({ 'StandardError' => 'null' }) }

  it { is_expected.to allow_value({ 'StandardInput' => 'socket' }) }
  it { is_expected.to allow_value({ 'StandardInput' => 'file:/tmp/inputfile' }) }
  it { is_expected.not_to allow_value({ 'StandardInput' => '/tmp/inputfile' }) }

  it { is_expected.to allow_value({ 'DynamicUser' => false }) }
  it { is_expected.to allow_value({ 'DynamicUser' => true }) }
  it { is_expected.not_to allow_value({ 'DynamicUser' => 'maybe' }) }

  it { is_expected.to allow_value({ 'SupplementaryGroups' => 'one' }) }
  it { is_expected.to allow_value({ 'SupplementaryGroups' => %w[one two] }) }
  it { is_expected.to allow_value({ 'SupplementaryGroups' => '' }) }
  it { is_expected.to allow_value({ 'SupplementaryGroups' => [''] }) }
  it { is_expected.to allow_value({ 'SupplementaryGroups' => ['', 'reset'] }) }
  it { is_expected.not_to allow_value({ 'SupplementaryGroups' => [] }) }

  it { is_expected.to allow_value({ 'WorkingDirectory' => '/var/lib/here' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '-/var/lib/here' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '~' }) }
  it { is_expected.to allow_value({ 'WorkingDirectory' => '' }) }

  it { is_expected.to allow_value({ 'LogLevelMax' => 'alert' }) }
  it { is_expected.not_to allow_value({ 'LogLevelMax' => 'top' }) }

  it { is_expected.to allow_value({ 'Nice' => -20 }) }
  it { is_expected.to allow_value({ 'Nice' => 19 }) }
  it { is_expected.not_to allow_value({ 'Nice' => '0' }) }

  it { is_expected.to allow_value({ 'CPUSchedulingPolicy' => 'idle' }) }
  it { is_expected.to allow_value({ 'CPUSchedulingPolicy' => '' }) }
  it { is_expected.not_to allow_value({ 'CPUSchedulingPolicy' => 'best-effort' }) }

  it { is_expected.to allow_value({ 'IOSchedulingClass' => 'best-effort' }) }
  it { is_expected.to allow_value({ 'IOSchedulingClass' => '' }) }
  it { is_expected.not_to allow_value({ 'IOSchedulingClass' => 'random' }) }

  it { is_expected.to allow_value({ 'IOSchedulingPriority' => 7 }) }
  it { is_expected.to allow_value({ 'IOSchedulingPriority' => '' }) }
  it { is_expected.not_to allow_value({ 'IOSchedulingPriority' => '0' }) }

  it { is_expected.to allow_value({ 'LimitMEMLOCK' => '100:100K' }) }

  it { is_expected.to allow_value({ 'MemoryAccounting' => true }) }

  it { is_expected.to allow_value({ 'CPUQuota' => '1%' }) }
  it { is_expected.to allow_value({ 'CPUQuota' => '110%' }) }

  it {
    is_expected.to allow_value(
      {
        'MemoryLow' => '100',
        'MemoryMin' => '10%',
        'MemoryHigh' => '8G',
        'MemoryMax' => 'infinity',
        'MemorySwapMax' => '1T',
      }
    )
  }

  it { is_expected.to allow_value({ 'MemorySwapMax' => '80%' }) }

  it { is_expected.not_to allow_value({ 'CPUQuota' => 50 }) }
  it { is_expected.not_to allow_value({ 'CPUQuota' => '0%' }) }
  it { is_expected.not_to allow_value({ 'MemoryHigh' => '1Y' }) }

  it { is_expected.to allow_value({ 'IODeviceWeight' => ['/dev/afs', 1000] }) }
  it { is_expected.to allow_value({ 'IODeviceWeight' => [['/dev/afs', 1000], ['/dev/gluster', 10]] }) }
  it { is_expected.not_to allow_value({ 'IODeviceWeight' => ['/dev/afs', 10_001] }) }
  it { is_expected.not_to allow_value({ 'IODeviceWeight' => ['absolute/path', 10_001] }) }
  it { is_expected.not_to allow_value({ 'IODeviceWeight' => '/dev/afs 1000' }) }

  %w[IOReadBandwidthMax IOWriteBandwidthMax IOWriteIOPSMax IOWriteIOPSMax].each do |device_size|
    context "with a key of #{device_size} can have a typle and size" do
      it {
        is_expected.to allow_value({ device_size => ['/dev/afs', 1000] })
        is_expected.to allow_value({ device_size => [['/dev/afs', 1000], ['/dev/gluster', '12G']] })
        is_expected.not_to allow_value({ device_size => '/dev/afs 1000' })
        is_expected.not_to allow_value({ device_size => [['absolute/path', 1000], ['/dev/gluster', '12G']] })
      }
    end
  end

  %w[ReadWritePaths ReadOnlyPaths InaccessiblePaths ExecPaths NoExecPaths].each do |depend|
    context "with a key of #{depend} can have values of string or array of strings" do
      it { is_expected.to allow_value({ depend => '+/var/log' }) }
      it { is_expected.to allow_value({ depend => ['-/var/log', '+/opt/', '-+/home'] }) }
      it { is_expected.not_to allow_value({ depend => 'foo bar blub' }) }
      it { is_expected.not_to allow_value({ depend => '+-/opt' }) }
    end
  end
end
