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
          is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d").with(
            ensure: 'directory',
            recurse: 'true',
            purge: 'true',
            selinux_ignore_defaults: false,
          )
        }

        it {
          is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with(
            ensure: 'file',
            content: %r{#{params[:content]}},
            mode: '0444',
            selinux_ignore_defaults: false,
          )
        }

        context 'with selinux_ignore_defaults set to true' do
          let(:params) do
            super().merge(selinux_ignore_defaults: true)
          end

          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d").with_selinux_ignore_defaults(true) }
          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with_selinux_ignore_defaults(true) }
        end

        context 'with daemon_reload => lazy (default)' do
          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").that_notifies('Class[systemd::systemctl::daemon_reload]') }

          it { is_expected.not_to create_exec("#{params[:unit]}-systemctl-daemon-reload") }
        end

        context 'with daemon_reload => eager' do
          let(:params) do
            super().merge(daemon_reload: 'eager')
          end

          it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").that_notifies("Exec[#{params[:unit]}-systemctl-daemon-reload]") }

          it { is_expected.to create_exec("#{params[:unit]}-systemctl-daemon-reload") }
        end

        context 'with a bad unit type' do
          let(:title) { 'test.badtype' }

          it {
            expect {
              is_expected.to compile.with_all_deps
            }.to raise_error(%r{expects a match for Systemd::Dropin})
          }
        end

        context 'with a bad unit type containing a slash' do
          let(:title) { 'test/bad.conf' }

          it {
            expect {
              is_expected.to compile.with_all_deps
            }.to raise_error(%r{expects a match for Systemd::Dropin})
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
            is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{params[:filename]}").with(
              ensure: 'file',
              content: %r{#{params[:content]}},
              mode: '0444',
            )
          }
        end
        context 'with sensitve content' do
          let(:title) { 'sensitive.conf' }
          let(:params) do
            {
              unit: 'sensitive.service',
              content: RSpec::Puppet::RawString.new("Sensitive('TEST_CONTENT')"),
            }
          end

          it {
            is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with(
              ensure: 'file',
              content: 'TEST_CONTENT',
            )
          }
        end
      end
    end
  end
end
