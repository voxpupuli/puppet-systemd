Systemd
=======

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/systemd.svg)](https://forge.puppetlabs.com/camptocamp/systemd)
[![Build Status](https://travis-ci.org/camptocamp/puppet-systemd.png?branch=master)](https://travis-ci.org/camptocamp/puppet-systemd)

Overview
--------

This module just declares an `Exec['systemctl-daemon-reload']` resource that you can use to refresh the daemon.

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
