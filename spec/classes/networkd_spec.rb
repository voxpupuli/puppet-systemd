# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::networkd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) do
        [
          'include systemd',
          # Fake assert_private function from stdlib to not fail within this test
          'function assert_private () { }',
        ]
      end

      # The data used for this test should match the hiera data example in the class documentation / readme
      let(:hiera_config) { 'spec/hiera.yaml' }

      # This should match the example in the class documentation / readme
      let(:interface_file) do
        <<~EOT
          #
          # This file is managed with puppet
          #
          # File name: 50-static.network
          #

          [Network]
          Gateway=192.168.0.1
          Address=192.168.0.15/24

          [Match]
          Name=enp2s0
        EOT
      end

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_file('/etc/systemd/network/50-static.network').
          with_content(interface_file)
      }
    end
  end
end
