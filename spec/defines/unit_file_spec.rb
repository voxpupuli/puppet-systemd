require 'spec_helper'

describe 'systemd::unit_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'test.service' }
        let(:params) { { content: 'random stuff' } }

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to create_file("/etc/systemd/system/#{title}")
            .with_ensure('file')
            .with_content(%r{#{params[:content]}})
            .with_mode('0444')
            .that_notifies('Class[systemd::systemctl::daemon_reload]')
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
              active: true,
            )
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_service('test.service')
              .with_ensure(true)
              .with_enable(true)
              .with_provider('systemd')
              .that_subscribes_to("File[/etc/systemd/system/#{title}]")
              .that_requires('Class[systemd::systemctl::daemon_reload]')
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
                active: false,
              )
            end

            it { is_expected.to compile.with_all_deps }
            it do
              is_expected.to contain_service('test.service')
                .with_ensure(false)
                .with_enable(false)
                .with_provider('systemd')
                .that_comes_before("File[/etc/systemd/system/#{title}]")
            end
          end
        end
      end
    end
  end
end
