# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::simpletimer' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'foobar.timer' }

        context('with command and weekly job') do
          let(:params) do
            {
              command: '/usr/bin/touch /tmp/file',
              timings: { OnCalendar: 'weekly' },
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_systemd__timer('foobar.timer').with(
              {
                ensure: 'present',
                timer_content: %r{^OnCalendar=weekly$},
                service_content: %r{^ExecStart=/usr/bin/touch /tmp/file$},
              }
            ).with(
              {
                timer_content: %r{^Description=Puppet configured timer$},
                service_content: %r{^Description=Puppet configured service$},
              }
            )
          }
        end

        context('on boot then once per hour after network and foo') do
          let(:params) do
            {
              command: '/usr/bin/touch /tmp/file',
              description: 'my special timer',
              timings: {
                OnBootSec: 0,
                OnActiveSec: '1h',
              },
              after: ['network.service', 'foo.service'],
            }
          end

          it {
            is_expected.to contain_systemd__timer('foobar.timer').with(
              {
                ensure: 'present',
                timer_content: %r{^OnActiveSec=1h$},
                service_content: %r{^ExecStart=/usr/bin/touch /tmp/file$},
              }
            ).with(
              {
                timer_content: %r{^OnBootSec=0$},
                service_content: %r{^After=network.service, foo.service$},
              }
            ).with(
              {
                timer_content: %r{^Description=Puppet configured timer : my special timer$},
                service_content: %r{^Description=Puppet configured service : my special timer$},
              }
            )
          }
        end
      end
    end
  end
end
