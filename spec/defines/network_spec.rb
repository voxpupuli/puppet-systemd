# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::network' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        # manage systemd-networkd service
        let :pre_condition do
          "class { 'systemd':
            manage_networkd => true,
          }"
        end

        let(:facts) { facts }

        let(:title) { 'eth0.network' }

        let(:params) do
          {
            content: 'random stuff',
            restart_service: true,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          expect(subject).to create_file("/etc/systemd/network/#{title}").with(
            ensure: 'file',
            content: %r{#{params[:content]}},
            mode: '0444'
          )
        }

        it { is_expected.to create_file("/etc/systemd/network/#{title}").that_notifies('Service[systemd-networkd]') }

        context 'with group => systemd-network, mode => 0640 and show_diff => false' do
          let(:title) { 'wg0.netdev' }

          let(:params) do
            {
              content: 'secret string',
              group: 'systemd-network',
              mode: '0640',
              show_diff: false,
              restart_service: true,
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).to create_file("/etc/systemd/network/#{title}").with(
              ensure: 'file',
              content: %r{#{params[:content]}},
              group: 'systemd-network',
              mode: '0640',
              show_diff: false
            )
          }

          it { is_expected.to create_file("/etc/systemd/network/#{title}").that_notifies('Service[systemd-networkd]') }
        end

        context 'without content and without source' do
          let :params do
            {}
          end

          it { is_expected.to compile.and_raise_error(%r{Either content or source must be set}) }
        end

        context 'with content and source' do
          let :params do
            {
              content: 'bla',
              source: 'foo'
            }
          end

          it { is_expected.to compile.and_raise_error(%r{Either content or source must be set but not both}) }
        end
      end
    end
  end
end
