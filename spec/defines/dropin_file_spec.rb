# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::dropin_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test.conf' }

        let(:params) do
          {
            unit: 'test.service',
            content: 'random stuff',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          expect(subject).to create_file("/etc/systemd/system/#{params[:unit]}.d").with(
            ensure: 'directory',
            recurse: 'true',
            purge: 'true',
            selinux_ignore_defaults: false
          )
        }

        it {
          expect(subject).to create_systemd__daemon_reload(params[:unit])
        }

        it {
          expect(subject).to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with(
            ensure: 'file',
            content: %r{#{params[:content]}},
            mode: '0444',
            selinux_ignore_defaults: false
          ).
            that_notifies("Systemd::Daemon_reload[#{params[:unit]}]")
        }

        context 'notifies services' do
          let(:params) do
            super().merge(notify_service: true)
          end
          let(:filename) { "/etc/systemd/system/#{params[:unit]}.d/#{title}" }
          let(:pre_condition) do
            <<-PUPPET
            service { ['test', 'test.service']:
            }
            PUPPET
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_service('test').that_subscribes_to("File[#{filename}]") }
          it { is_expected.to contain_service('test.service').that_subscribes_to("File[#{filename}]") }

          context 'with overridden name' do
            let(:pre_condition) do
              <<-PUPPET
              service { 'myservice':
                name => 'test',
              }
              PUPPET
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_service('myservice').that_subscribes_to("File[#{filename}]") }
            it { is_expected.to contain_systemd__daemon_reload(params[:unit]).that_notifies('Service[myservice]') }
          end
        end

        context 'with selinux_ignore_defaults set to true' do
          let(:params) do
            super().merge(selinux_ignore_defaults: true)
          end

          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d").with_selinux_ignore_defaults(true) }
          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with_selinux_ignore_defaults(true) }
        end

        context 'with a bad unit type' do
          let(:title) { 'test.badtype' }

          it {
            expect do
              expect(subject).to compile.with_all_deps
            end.to raise_error(%r{expects a match for Systemd::Dropin})
          }
        end

        context 'with a bad unit type containing a slash' do
          let(:title) { 'test/bad.conf' }

          it {
            expect do
              expect(subject).to compile.with_all_deps
            end.to raise_error(%r{expects a match for Systemd::Dropin})
          }
        end

        context 'with another drop-in file with the same filename (and content)' do
          let(:default_params) do
            {
              filename: 'longer-timeout.conf',
              content: 'random stuff',
            }
          end
          # Create drop-in file longer-timeout.conf for unit httpd.service
          let(:pre_condition) do
            "systemd::dropin_file { 'httpd_longer-timeout':
              filename => '#{default_params[:filename]}',
              unit     => 'httpd.service',
              content  => '#{default_params[:context]}',
            }"
          end
          #
          # Create drop-in file longer-timeout.conf for unit ftp.service
          let(:title) { 'ftp_longer-timeout' }
          let(:params) do
            default_params.merge(unit: 'ftp.service')
          end

          it {
            expect(subject).to create_file("/etc/systemd/system/#{params[:unit]}.d/#{params[:filename]}").with(
              ensure: 'file',
              content: %r{#{params[:content]}},
              mode: '0444'
            )
          }
        end

        context 'with sensitive content' do
          let(:title) { 'sensitive.conf' }
          let(:params) do
            {
              unit: 'sensitive.service',
              content: RSpec::Puppet::RawString.new("Sensitive('TEST_CONTENT')"),
            }
          end

          it {
            expect(subject).to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with(
              ensure: 'file',
              content: sensitive('TEST_CONTENT')
            )
          }
        end

        context 'with daemon_reload = false' do
          let(:params) do
            super().merge(daemon_reload: false)
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).not_to create_systemd__daemon_reload(params[:unit])
          }
        end
      end
    end
  end
end
