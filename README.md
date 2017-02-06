# Systemd

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/systemd.svg)](https://forge.puppetlabs.com/camptocamp/systemd)
[![Build Status](https://travis-ci.org/camptocamp/puppet-systemd.png?branch=master)](https://travis-ci.org/camptocamp/puppet-systemd)

## Overview

This module declares exec resources to create global sync points for reloading systemd.

## Usage and examples

There are two ways to use this module.

### unit files

Let this module handle file creation and systemd reloading.

```puppet
::systemd::unit_file { 'foo.service':
 source => "puppet:///modules/${module_name}/foo.service",
}
```
Or specify a settings hash for a new unit file.

```puppet
::systemd::unit_file{ 'foo.service':
   settings => { 'Description'     => 'the foo service',
                 'ExecStart'       => '/bin/foo',
                 'Wants'           => ['network.target', 'bar.service'],
                 'Type'            => 'oneshot',
                 'EnvironmentFile' => ['-/etc/sysconfig/foo','/etc/sysconfig/myfoo'],
               }
}
```
The following keys for the settings hash are supported: `Description`, `Requires`, `Conflicts`, `Wants`,
`After`, `Type`, `ExecStart`, `ExecStop`, `ExecReload`, `Environment`, `EnvironmentFile`, `WorkingDirectory`,
`Restart`, `RestartSec`, `RestartAfterExec` and`WantedBy`. If a value is specified as an array multiple
lines will be added to the unit file.


Or handle file creation yourself and trigger systemd.

```puppet
include ::systemd
file { '/usr/lib/systemd/system/foo.service':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => "puppet:///modules/${module_name}/foo.service",
} ~>
Exec['systemctl-daemon-reload']
```

### tmpfiles

Let this module handle file creation and systemd reloading

```puppet
::systemd::tmpfile { 'foo.conf':
  source => "puppet:///modules/${module_name}/foo.conf",
}
```

Or handle file creation yourself and trigger systemd.

```puppet
include ::systemd
file { '/etc/tmpfiles.d/foo.conf':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => "puppet:///modules/${module_name}/foo.conf",
} ~>
Exec['systemd-tmpfiles-create']
```

### service limits

Manage soft and hard limits on various resources for executed processes.

```puppet
::systemd::service_limits { 'foo.service':
  limits => {
    LimitNOFILE => 8192,
    LimitNPROC  => 16384
  }
}
```

Or provide the configuration file yourself. Systemd reloading and restarting of the service are handled by the module.

```puppet
::systemd::service_limits { 'foo.service':
  source => "puppet:///modules/${module_name}/foo.conf",
}
```
