# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::unit_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'test.service' }
        let(:params) { { content: 'random stuff' } }

        it { is_expected.to compile.with_all_deps }

        context 'with defaults' do
          it do
            expect(subject).to create_systemd__daemon_reload(title)
          end

          it do
            expect(subject).to contain_file("/etc/systemd/system/#{title}").
              with_selinux_ignore_defaults(false).
              that_notifies("Systemd::Daemon_reload[#{title}]")
          end
        end

        context 'selinux_ignore_defaults => false' do
          let(:params) { { selinux_ignore_defaults: false } }

          it do
            expect(subject).to contain_file("/etc/systemd/system/#{title}").
              with_selinux_ignore_defaults(false)
          end
        end

        context 'selinux_ignore_defaults => true' do
          let(:params) { { selinux_ignore_defaults: true } }

          it do
            expect(subject).to contain_file("/etc/systemd/system/#{title}").
              with_selinux_ignore_defaults(true)
          end
        end

        context 'with non-sensitive Content' do
          let(:params) { { content: 'non-sensitive Content' } }

          it do
            expect(subject).to create_file("/etc/systemd/system/#{title}").
              with_ensure('file').
              with_content(params[:content]).
              with_mode('0444')
          end
        end

        context 'with sensitive Content' do
          let(:params) { { content: sensitive('sensitive Content') } }

          it do
            resource = catalogue.resource("File[/etc/systemd/system/#{title}]")
            expect(resource[:content]).to eq(params[:content].unwrap)

            expect(subject).to contain_file("/etc/systemd/system/#{title}").
              with({ content: sensitive('sensitive Content') })
          end
        end

        context 'with a bad unit type' do
          let(:title) { 'test.badtype' }

          it { is_expected.to compile.and_raise_error(%r{expects a match for Systemd::Unit}) }
        end

        context 'with a bad unit type containing a slash' do
          let(:title) { 'test/unit.service' }

          it { is_expected.to compile.and_raise_error(%r{expects a match for Systemd::Unit}) }
        end

        context 'with enable => true and active => true' do
          let(:params) do
            super().merge(
              enable: true,
              active: true
            )
          end

          it { is_expected.to compile.with_all_deps }

          it do
            expect(subject).to contain_service('test.service').
              with_ensure(true).
              with_enable(true).
              with_provider('systemd').
              without_hasstatus.
              without_hasrestart.
              without_flags.
              without_timeout.
              that_subscribes_to("File[/etc/systemd/system/#{title}]").
              that_subscribes_to("Systemd::Daemon_reload[#{title}]")
          end
        end

        context 'with enable => true and active => true and service_parameters' do
          let(:params) do
            super().merge(
              enable: true,
              active: true,
              service_parameters: {
                flags: '--awesome',
                timeout: 1337
              }
            )
          end

          it { is_expected.to compile.with_all_deps }

          it do
            expect(subject).to contain_service('test.service').
              with_ensure(true).
              with_enable(true).
              with_provider('systemd').
              without_hasstatus.
              without_hasrestart.
              with_flags('--awesome').
              with_timeout(1337).
              that_subscribes_to("File[/etc/systemd/system/#{title}]")
          end
        end

        context 'ensure => absent' do
          let(:params) { super().merge(ensure: 'absent') }

          context 'with enable => true' do
            let(:params) { super().merge(enable: true) }

            it { is_expected.to compile.and_raise_error(%r{Can't ensure the unit file is absent and activate}) }
          end

          context 'with active => true' do
            let(:params) { super().merge(active: true) }

            it { is_expected.to compile.and_raise_error(%r{Can't ensure the unit file is absent and activate}) }
          end

          context 'with enable => false and active => false' do
            let(:params) do
              super().merge(
                enable: false,
                active: false
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              expect(subject).to contain_service('test.service').
                with_ensure(false).
                with_enable(false).
                with_provider('systemd').
                that_comes_before("File[/etc/systemd/system/#{title}]")
            end
          end
        end

        context 'enable => mask' do
          let(:params) { { enable: 'mask' } }

          it do
            expect(subject).to create_file("/etc/systemd/system/#{title}").
              with_ensure('link').
              with_target('/dev/null')
          end
        end

        context 'with daemon_reload = false' do
          let(:params) do
            super().merge(daemon_reload: false)
          end

          it { is_expected.to compile.with_all_deps }

          it {
            expect(subject).not_to create_systemd__daemon_reload(title)
          }
        end
      end
    end
  end
end
