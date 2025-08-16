# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::networkd::interface' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:pre_condition) { 'include systemd' }
        let(:title) { 'static-enp2s0' }

        # This should match the example in the class documentation / readme
        let(:params) do
          {
            type: 'network',
            interface: {
              filename: '50-static',
              network: {
                Match: {
                  Name: 'enp2s0',
                },
                Network: {
                  Address: '192.168.0.15/24',
                },
              },
            },
            network_profile: {
              Network: {
                Gateway: '192.168.0.1',
              },
            }
          }
        end

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
end
