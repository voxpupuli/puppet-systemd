require 'spec_helper'

describe 'systemd::unit_file' do

  let(:facts) { {
      :path => '/usr/bin',
  } }

  context 'default params' do

    let(:title) { 'fancy.service' }

    it 'creates the unit file' do
      should contain_file('/etc/systemd/system/fancy.service').with({
                                                                        'ensure' => 'file',
                                                                        'owner' => 'root',
                                                                        'group' => 'root',
                                                                        'mode' => '0444',
                                                                    })
    end

    it 'triggers systemd daemon-reload' do
      should contain_class('systemd')
      should contain_file('/etc/systemd/system/fancy.service').with_notify("Exec[systemctl-daemon-reload]")
    end
  end

  context 'with params' do
    let(:title) { 'fancy.service' }

    let(:params) { {
        :ensure => 'absent',
        :path => '/usr/lib/systemd/system',
        :content => 'some-content',
        :source => 'some-source',
        :target => 'some-target',
    } }

    it 'creates the unit file' do
      should contain_file('/usr/lib/systemd/system/fancy.service').with({
                                                                            'ensure' => 'absent',
                                                                            'content' => 'some-content',
                                                                            'source' => 'some-source',
                                                                            'target' => 'some-target',
                                                                        })
    end

  end

end
