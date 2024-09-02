# frozen_string_literal: true

require 'spec_helper'

describe 'systemd::manage_unit' do
  _, facts = on_supported_os.first
  let(:facts) { facts }

  let(:title) { 'foobar.service' }

  context 'with an arrayed description and simple parameters set' do
    let(:params) do
      {
        unit_entry: {
          Description: ['My great service', 'has two lines of description'],
          DefaultDependencies: true,
        },
        service_entry: {
          Type: 'oneshot',
          ExecStart: '/usr/bin/doit.sh',
          SyslogIdentifier: 'doit-backwards.sh',
          Environment: ['bla=foo', 'foo=bla'],
          IOReadIOPSMax: ['/dev/afs', '1K'],
        },
        install_entry: {
          WantedBy: 'multi-user.target',
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_systemd__unit_file('foobar.service').
        with_content(%r{^\[Unit\]$}).
        with_content(%r{^DefaultDependencies=true$}).
        with_content(%r{^\[Service\]$}).
        with_content(%r{^SyslogIdentifier=doit-backwards\.sh$}).
        with_content(%r{^Environment=bla=foo$}).
        with_content(%r{^Environment=foo=bla$}).
        with_content(%r{^\[Install\]$}).
        with_content(%r{^Description=My great service$}).
        with_content(%r{^Description=has two lines of description$}).
        with_content(%r{^Type=oneshot$}).
        with_content(%r{^IOReadIOPSMax=/dev/afs 1K$}).
        without_content(%r{^\[Slice\]$})
    }

    context 'with no service_entry' do
      let(:params) do
        {
          ensure: 'present',
        }
      end

      it { is_expected.to compile.and_raise_error(%r{service_entry is required for service units}) }

      context 'with ensure absent' do
        let(:params) do
          super().merge(ensure: 'absent')
        end

        it { is_expected.to contain_systemd__unit_file('foobar.service').with_ensure('absent') }
      end
    end

    context 'with a timer entry' do
      let(:params) do
        super().merge(timer_entry: { 'OnCalendar' => 'something' })
      end

      it { is_expected.to compile.and_raise_error(%r{timer_entry is only valid for timer units}) }
    end

    context 'with a slice entry' do
      let(:params) do
        super().merge(slice_entry: { 'IOWeight' => 100 })
      end

      it { is_expected.to compile.and_raise_error(%r{slice_entry is only valid for slice units}) }
    end

    context 'with a path entry' do
      let(:params) do
        super().merge(path_entry: { 'PathExists' => '/etc/passwd' })
      end

      it { is_expected.to compile.and_raise_error(%r{path_entry is only valid for path units}) }
    end

    context 'with a socket entry' do
      let(:params) do
        super().merge(socket_entry: { 'ListenStream' => '1337' })
      end

      it { is_expected.to compile.and_raise_error(%r{socket_entry is only valid for socket units}) }
    end
  end

  context 'on a timer' do
    let(:title) { 'winter.timer' }

    let(:params) do
      {
        unit_entry: {
          Description: 'Winter is coming',
        },
        timer_entry: {
          'OnActiveSec' => '5min',
          'OnBootSec' => ['', '1min 5s'],
          'OnStartUpSec' => 10,
          'OnUnitActiveSec' => '5s',
          'OnUnitInactiveSec' => ['', 10],
          'OnCalendar' => 'soon',
          'AccuracySec' => '24h',
          'RandomizedDelaySec' => '4min 20s',
          'FixedRandomDelay' => true,
          'OnClockChange' => false,
          'OnTimezoneChange' => true,
          'Unit' => 'summer.service',
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_systemd__unit_file('winter.timer').
        with_content(%r{^\[Timer\]$}).
        with_content(%r{^OnActiveSec=5min$}).
        with_content(%r{^OnBootSec=$}).
        with_content(%r{^OnBootSec=1min 5s$}).
        with_content(%r{^OnStartUpSec=10$}).
        with_content(%r{^OnUnitActiveSec=5s$}).
        with_content(%r{^OnUnitInactiveSec=$}).
        with_content(%r{^OnUnitInactiveSec=10$}).
        with_content(%r{^OnCalendar=soon$}).
        with_content(%r{^AccuracySec=24h$}).
        with_content(%r{^RandomizedDelaySec=4min 20s$}).
        with_content(%r{^FixedRandomDelay=true$}).
        with_content(%r{^OnClockChange=false$}).
        with_content(%r{^OnTimezoneChange=true$}).
        with_content(%r{^Unit=summer.service$})
    }
  end

  context 'on a socket unit' do
    let(:title) { 'arcd.socket' }
    let(:params) do
      {
        unit_entry: {
          Description: 'A crazy socket',
        },
        socket_entry: {
          'ListenStream' => 4241,
          'Accept'       => true,
          'BindIPv6Only' => 'both'
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_systemd__unit_file('arcd.socket').
        with_content(%r{^\[Socket\]$}).
        with_content(%r{^ListenStream=4241$}).
        with_content(%r{^Accept=true$}).
        with_content(%r{^BindIPv6Only=both$})
    }
  end

  context 'on a slice unit' do
    let(:title) { 'myslice.slice' }
    let(:params) do
      {
        unit_entry: {
          Description: 'A crazy slice',
        },
        slice_entry: {
          'MemoryMax' => '10G',
          'IOAccounting' => true,
          'IOWriteIOPSMax' => [
            ['/dev/gluster', 20],
            ['/dev/afs', '50K'],
          ],
        },
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_systemd__unit_file('myslice.slice').
        with_content(%r{^\[Slice\]$}).
        with_content(%r{^MemoryMax=10G$}).
        with_content(%r{^IOAccounting=true$}).
        with_content(%r{^IOWriteIOPSMax=/dev/gluster 20$}).
        with_content(%r{^IOWriteIOPSMax=/dev/afs 50K$}).
        without_content(%r{^\[Service\]$})
    }
  end

  context 'on a path unit' do
    let(:title) { 'etc-passwd.path' }

    let(:params) do
      {
        unit_entry: {
          Description: 'Watch that passwd like a hawk',
        },
        path_entry: {
          'PathExists'              => '/etc/passwd',
          'PathExistsGlob'          => '/etc/krb5.conf.d/*.conf',
          'PathChanged'             => '',
          'PathModified'            => ['', '/etc/httpd/conf.d/*.conf'],
          'DirectoryNotEmpty'       => '/tmp',
          'Unit'                    => 'my.service',
          'MakeDirectory'           => true,
          'DirectoryMode'           => '0777',
          'TriggerLimitIntervalSec' => '10s',
          'TriggerLimitBurst'       => 100,
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_systemd__unit_file('etc-passwd.path').
        without_content(%r{^\[Service\]$}).
        with_content(%r{^\[Path\]$}).
        with_content(%r{^PathExists=/etc/passwd$}).
        with_content(%r{^PathExistsGlob=/etc/krb5.conf.d/\*.conf$}).
        with_content(%r{^PathChanged=$}).
        with_content(%r{^PathModified=$}).
        with_content(%r{^PathModified=/etc/httpd/conf.d/\*.conf$}).
        with_content(%r{^DirectoryNotEmpty=/tmp$}).
        with_content(%r{^Unit=my.service$}).
        with_content(%r{^MakeDirectory=true$}).
        with_content(%r{^DirectoryMode=0777$}).
        with_content(%r{^TriggerLimitIntervalSec=10s$}).
        with_content(%r{^TriggerLimitBurst=100$})
    }
  end
end
