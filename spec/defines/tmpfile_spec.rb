require 'spec_helper'

describe 'systemd::tmpfile' do

  let(:facts) { {
      :path => '/usr/bin',
  } }

  context 'default params' do

    let(:title) { 'fancy.conf' }

    it 'creates the tmpfile' do
      should contain_file('/etc/tmpfiles.d/fancy.conf').with({
                                                                 'ensure' => 'file',
                                                                 'owner' => 'root',
                                                                 'group' => 'root',
                                                                 'mode' => '0444',
                                                             })
    end

    it 'triggers systemd daemon-reload' do
      should contain_class('systemd')
      should contain_file('/etc/tmpfiles.d/fancy.conf').with_notify("Exec[systemd-tmpfiles-create]")
    end
  end

  context 'with params' do
    let(:title) { 'fancy.conf' }

    let(:params) { {
        :ensure => 'absent',
        :path => '/etc/tmpfiles.d/foo',
        :content => 'some-content',
        :source => 'some-source',
    } }

    it 'creates the unit file' do
      should contain_file('/etc/tmpfiles.d/foo/fancy.conf').with({
                                                                     'ensure' => 'absent',
                                                                     'content' => 'some-content',
                                                                     'source' => 'some-source',
                                                                 })
    end

  end

end
