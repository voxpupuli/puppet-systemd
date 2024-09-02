# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::service_limits' do
  _, facts = on_supported_os.first
  let(:facts) { facts }

  let(:title) { 'test.service' }

  # Whole type is deprecated but check it still works.
  before do
    Puppet.settings[:strict] = :warning
  end

  describe 'with limits and present' do
    let(:params) do
      {
        limits: {
          'LimitCPU' => '10m',
          'LimitFSIZE' => 'infinity',
          'LimitDATA' => '10K',
          'LimitNOFILE' => '20:infinity',
          'LimitNICE' => '-10',
          'LimitRTPRIO' => 50,
          'MemorySwapMax' => '0',
          'CPUQuota' => '125%',
          'IODeviceWeight' => [
            { '/dev/weight' => 10 },
            { '/dev/weight2' => 20 },
          ],
          'IOReadBandwidthMax' => [
            { '/bw/max' => '10K' },
          ],
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_systemd__manage_dropin("#{title}-90-limits.conf").with_ensure('present') }

    it {
      expect(subject).to create_file("/etc/systemd/system/#{title}.d/90-limits.conf").
        with(ensure: 'file', mode: '0444').
        with_content(%r{LimitCPU=10m}).
        with_content(%r{LimitFSIZE=infinity}).
        with_content(%r{LimitDATA=10K}).
        with_content(%r{LimitNOFILE=20:infinity}).
        with_content(%r{LimitNICE=-10}).
        with_content(%r{LimitRTPRIO=50}).
        with_content(%r{MemorySwapMax=0}).
        with_content(%r{CPUQuota=125%}).
        with_content(%r{IODeviceWeight=/dev/weight 10}).
        with_content(%r{IODeviceWeight=/dev/weight2 20}).
        with_content(%r{IOReadBandwidthMax=/bw/max 10K})
    }

    describe 'with service managed' do
      let(:pre_condition) do
        <<-PUPPET
        service { 'test':
        }
        PUPPET
      end

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to create_file("/etc/systemd/system/#{title}.d/90-limits.conf").
          that_notifies('Service[test]')
      end
    end
  end

  describe 'source specified' do
    let(:params) { { source: 'puppet:///mine/content' } }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_systemd__dropin_file("#{title}-90-limits.conf").with_ensure('present') }
  end

  describe 'ensured absent' do
    let(:params) { { ensure: 'absent' } }

    it { is_expected.to compile.with_all_deps }

    it do
      expect(subject).to create_file("/etc/systemd/system/#{title}.d/90-limits.conf").
        with_ensure('absent')
    end
  end
end
