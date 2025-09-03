# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::networkd::interface' do
  shared_examples 'systemd::networkd::interface example' do
    let(:pre_condition) { 'include systemd' }
    it { is_expected.to compile.with_all_deps }

    it {
      if params[:interface].key?(:network)
        is_expected.to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.network")
      else
        is_expected.not_to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.network")
      end
    }

    it {
      if params[:interface].key?(:netdev)
        is_expected.to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.netdev")
      else
        is_expected.not_to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.netdev")
      end
    }

    it {
      if params[:interface].key?(:link)
        is_expected.to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.link")
      else
        is_expected.not_to contain_file("/etc/systemd/network/#{params[:interface][:filename]}.link")
      end
    }
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'static-enp2s0' }

        context 'network with a profile' do
          # This should match the example in the class documentation / readme
          let(:params) do
            {
              interface: {
                filename: '51-static',
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
              # File name: 51-static.network
              #

              [Network]
              Gateway=192.168.0.1
              Address=192.168.0.15/24

              [Match]
              Name=enp2s0
            EOT
          end

          it_behaves_like 'systemd::networkd::interface example'

          it {
            is_expected.to contain_file('/etc/systemd/network/51-static.network').
              with_content(interface_file)
          }
        end

        context 'network vrf interface' do
          let(:title) { 'vrf' }
          let(:params) do
            {
              interface: {
                filename: '50-vrf',
                network: {
                  Match: {
                    Name: 'vrf',
                  },
                  Network: {
                    Address: '192.168.24.15/24',
                  },
                },
                netdev: {
                  NetDev: {
                    Name: 'vrf',
                    Kind: 'vrf',
                  },
                  VRF: {
                    Table: 42,
                  },
                }
              }
            }
          end

          it_behaves_like 'systemd::networkd::interface example'
        end
      end
    end
  end
end
