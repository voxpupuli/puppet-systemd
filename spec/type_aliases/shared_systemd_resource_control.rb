# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'systemd_resource_control' do
  context 'AllowedCPUs=' do
    it { is_expected.not_to allow_value({ 'AllowedCPUs' => '-4' }) }
    it { is_expected.not_to allow_value({ 'AllowedCPUs' => '' }) }
    it { is_expected.not_to allow_value({ 'AllowedCPUs' => '0-' }) }
    it { is_expected.not_to allow_value({ 'AllowedCPUs' => '0,,4' }) }
    it { is_expected.not_to allow_value({ 'AllowedCPUs' => 'abc' }) }
    it { is_expected.to allow_value({ 'AllowedCPUs' => '0-2,4' }) }
    it { is_expected.to allow_value({ 'AllowedCPUs' => '0-4' }) }
    it { is_expected.to allow_value({ 'AllowedCPUs' => '0-7,16-23' }) }
    it { is_expected.to allow_value({ 'AllowedCPUs' => '0,1,2,3,4' }) }
    it { is_expected.to allow_value({ 'AllowedCPUs' => '0' }) }
  end

  context 'CPUQuota=' do
    it { is_expected.not_to allow_value({ 'CPUQuota' => '0%' }) }
    it { is_expected.not_to allow_value({ 'CPUQuota' => 50 }) }
    it { is_expected.to allow_value({ 'CPUQuota' => :undef }) }
    it { is_expected.to allow_value({ 'CPUQuota' => '1%' }) }
    it { is_expected.to allow_value({ 'CPUQuota' => '110%' }) }
  end

  context 'CPUWeight=' do
    it { is_expected.to allow_value({ 'CPUWeight' => 'idle' }) }
    it { is_expected.to allow_value({ 'CPUWeight' => 100 }) }
  end

  # === Device policy ===
  context 'DeviceAllow=' do
    it { is_expected.not_to allow_value({ 'DeviceAllow' => '' }) }
    it { is_expected.not_to allow_value({ 'DeviceAllow' => 'random' }) }
    it { is_expected.to allow_value({ 'DeviceAllow' => '/dev/null rw' }) }
    it { is_expected.to allow_value({ 'DeviceAllow' => '/dev/sda1' }) }
    it { is_expected.to allow_value({ 'DeviceAllow' => 'block-loop' }) }
  end

  context 'DevicePolicy=' do
    %w[auto closed strict].each do |val|
      it { is_expected.to allow_value({ 'DevicePolicy' => val }) }
    end
    it { is_expected.not_to allow_value({ 'DevicePolicy' => 'open' }) }
  end

  # === I/O resource accounting and limits ===
  context 'IOAccounting=' do
    it { is_expected.to allow_value({ 'IOAccounting' => false }) }
    it { is_expected.to allow_value({ 'IOAccounting' => true }) }
  end

  context 'IOWeight= and StartupIOWeight=' do
    it { is_expected.not_to allow_value({ 'IOWeight' => 0 }) }
    it { is_expected.not_to allow_value({ 'IOWeight' => 10_001 }) }
    it { is_expected.to allow_value({ 'IOWeight' => 1 }) }
    it { is_expected.to allow_value({ 'IOWeight' => 10_000 }) }
    it { is_expected.to allow_value({ 'IOWeight' => 100 }) }
    it { is_expected.to allow_value({ 'StartupIOWeight' => 500 }) }
  end

  context 'IODeviceWeight=' do
    it { is_expected.not_to allow_value({ 'IODeviceWeight' => '/dev/sda 1000' }) }
    it { is_expected.not_to allow_value({ 'IODeviceWeight' => ['/dev/sda', 10_001] }) }
    it { is_expected.not_to allow_value({ 'IODeviceWeight' => ['relative/path', 1000] }) }
    it { is_expected.to allow_value({ 'IODeviceWeight' => ['/dev/sda', 1000] }) }
    it { is_expected.to allow_value({ 'IODeviceWeight' => [['/dev/sda', 1000], ['/dev/sdb', 500]] }) }
  end

  %w[IOReadBandwidthMax IOWriteBandwidthMax IOReadIOPSMax IOWriteIOPSMax].each do |key|
    context "#{key}=" do
      it { is_expected.not_to allow_value({ key => '/dev/sda 1000' }) }
      it { is_expected.not_to allow_value({ key => [['relative/path', 1000], ['/dev/sdb', '12G']] }) }
      it { is_expected.to allow_value({ key => ['/dev/sda', 1000] }) }
      it { is_expected.to allow_value({ key => [['/dev/sda', 1000], ['/dev/sdb', '12G']] }) }
    end
  end

  # IPs
  context 'IPAccounting=' do
    it { is_expected.to allow_value({ 'IPAccounting' => true }) }
  end

  context 'IPAddressAllow=' do
    it { is_expected.to allow_value({ 'IPAddressAllow' => 'any' }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => 'link-local' }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => 'localhost' }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => 'multicast' }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => %w[172.16.0.0/12 192.168.0.0/16] }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => %w[172.16.0.1 192.168.0.1] }) }
    it { is_expected.to allow_value({ 'IPAddressAllow' => %w[172.16.0.1] }) }
  end

  context 'IPAddressDeny=' do
    it { is_expected.to allow_value({ 'IPAddressDeny' => 'any' }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => 'link-local' }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => 'localhost' }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => 'multicast' }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => %w[172.16.0.0/12 192.168.0.0/16] }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => %w[172.16.0.1 192.168.0.1] }) }
    it { is_expected.to allow_value({ 'IPAddressDeny' => %w[172.16.0.1] }) }
  end

  # === Memory resource accounting and limits ===
  context 'MemoryAccounting=' do
    it { is_expected.to allow_value({ 'MemoryAccounting' => false }) }
    it { is_expected.to allow_value({ 'MemoryAccounting' => true }) }
  end

  context 'Memory limits (AmountOrPercent)' do
    it {
      is_expected.to allow_value(
        {
          'MemoryHigh' => '8G',
          'MemoryLow' => '100',
          'MemoryMax' => 'infinity',
          'MemoryMin' => '10%',
          'MemorySwapMax' => '1T',
        },
      )
    }

    it { is_expected.not_to allow_value({ 'MemoryHigh' => '1Y' }) }
    it { is_expected.to allow_value({ 'MemorySwapMax' => '80%' }) }
  end

  # === Slice= and Delegate= ===
  context 'Slice=' do
    it { is_expected.to allow_value({ 'Slice' => 'system.slice' }) }
    it { is_expected.not_to allow_value({ 'Slice' => '' }) }
  end

  context 'Delegate=' do
    it { is_expected.to allow_value({ 'Delegate' => true }) }
    it { is_expected.to allow_value({ 'Delegate' => false }) }
    it { is_expected.not_to allow_value({ 'Delegate' => 'yes' }) }
  end

  # === Task limits ===
  context 'TasksAccounting=' do
    it { is_expected.to allow_value({ 'TasksAccounting' => false }) }
    it { is_expected.to allow_value({ 'TasksAccounting' => true }) }
  end

  context 'TasksMax=' do
    it { is_expected.to allow_value({ 'TasksMax' => '100' }) }
    it { is_expected.to allow_value({ 'TasksMax' => '50%' }) }
    it { is_expected.to allow_value({ 'TasksMax' => 'infinity' }) }
  end
end
