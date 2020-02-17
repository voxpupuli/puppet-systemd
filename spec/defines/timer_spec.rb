require 'spec_helper'

describe 'systemd::timer' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'foobar.timer' }

        context('with timer_content and service_content') do
          let(:params) do
            {
              timer_content: "[Timer]\nOnCalendar=weekly",
              service_content: "[Service]\nExecStart=/bin/touch /tmp/foobar",
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__unit_file('foobar.timer').with(
              content: "[Timer]\nOnCalendar=weekly",
            )
          }

          it {
            is_expected.to contain_systemd__unit_file('foobar.service').with(
              content: "[Service]\nExecStart=/bin/touch /tmp/foobar",
            )
          }
        end

        context('with timer_source and service_source') do
          let(:params) do
            {
              timer_source: 'puppet:///timer',
              service_source: 'puppet:///source',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__unit_file('foobar.timer').with_source('puppet:///timer') }
          it { is_expected.to contain_systemd__unit_file('foobar.service').with_source('puppet:///source') }
        end

        context('with timer_source only set') do
          let(:params) do
            {
              timer_source: 'puppet:///timer',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_systemd__unit_file('foobar.timer').with_source('puppet:///timer') }
          it { is_expected.not_to contain_systemd__unit_file('foobar.service') }
        end

        context 'with service_unit specified' do
          let(:params) do
            {
              timer_content: "[Timer]\nOnCalendar=weekly",
              service_content: "[Service]\nExecStart=/bin/touch /tmp/foobar",
              service_unit: 'gamma.service',
            }
          end

          it { is_expected.to contain_systemd__unit_file('foobar.timer').with_content("[Timer]\nOnCalendar=weekly") }

          it { is_expected.to contain_systemd__unit_file('gamma.service').with_content("[Service]\nExecStart=/bin/touch /tmp/foobar") }
        end

        context 'with a bad timer name' do
          let(:title) { 'foobar' }

          it {
            expect {
              is_expected.to compile.with_all_deps
            }.to raise_error(%r{expects a match for})
          }
        end
      end
    end
  end
end
