# Systemd

[![Build Status](https://github.com/voxpupuli/puppet-systemd/actions/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-systemd/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-systemd/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-systemd/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/voxpupuli/systemd.svg)](https://forge.puppet.com/puppet/systemd)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/voxpupuli/systemd.svg)](https://forge.puppet.com/puppet/systemd)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/voxpupuli/systemd.svg)](https://forge.puppet.com/puppet/systemd)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/voxpupuli/systemd.svg)](https://forge.puppet.com/puppet/systemd)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-systemd.svg)](/voxpupuli/puppet-systemd/blob/master/LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [What this module manages](#what-this-module-manages)
- [Getting started](#getting-started)
- [The systemd class: tuning what is managed](#the-systemd-class--tuning-what-is-managed)
- [The defined types](#the-defined-types)
  - [Which resource do I use?](#which-resource-do-i-use)
  - [systemd::unit_file -- deploy a unit file](#systemd--unit_file---deploy-a-unit-file)
  - [systemd::manage_unit -- generate a unit from parameters](#systemd--manage_unit---generate-a-unit-from-parameters)
  - [systemd::dropin_file / systemd::manage_dropin -- extend a unit](#systemd--dropin_file--systemd--manage_dropin---extend-a-unit)
  - [Strongly-typed daemon config drop-ins](#strongly-typed-daemon-config-drop-ins)
  - [systemd::modules_load -- load kernel modules](#systemd--modules_load---load-kernel-modules)
  - [systemd::sysuser -- create system users](#systemd--sysuser---create-system-users)
  - [systemd::tmpfile -- manage tmpfiles.d entries](#systemd--tmpfile---manage-tmpfilesd-entries)
  - [systemd::timer / systemd::timer_wrapper -- schedule tasks](#systemd--timer--systemd--timer_wrapper---schedule-tasks)
  - [systemd::network / systemd::networkd::interface -- network configuration](#systemd--network--systemd--networkd--interface---network-configuration)
  - [systemd::user_service -- manage user services](#systemd--user_service---manage-user-services)
  - [systemd::purge_units -- remove unmanaged units](#systemd--purge_units---remove-unmanaged-units)
  - [systemd::daemon_reload / systemd::daemon_reexec -- reload systemd](#systemd--daemon_reload--systemd--daemon_reexec---reload-systemd)
- [Advanced configuration](#advanced-configuration)
  - [Two ways to configure a daemon](#two-ways-to-configure-a-daemon)
  - [Daemon reload behaviour](#daemon-reload-behaviour)
  - [systemd-escape on the agent](#systemd-escape-on-the-agent)
  - [Query units with Bolt](#query-units-with-bolt)
- [Limitations and deprecations](#limitations-and-deprecations)
- [Development](#development)
- [Support and authors](#support-and-authors)

---

## Overview

`puppet-systemd` manages [systemd](https://www.freedesktop.org/software/systemd/man/latest/index.html)
across its whole surface area: unit files, drop-in overrides, timers, network
configuration, kernel modules, system users, and many systemd-managed daemons.

Instead of declaring raw `exec { 'systemctl daemon-reload': }` resources, you
declare declarative Puppet resources such as `systemd::unit_file` and
`systemd::manage_unit`. The module writes the correct files under `/etc/systemd`,
runs the right `systemctl`/`systemd-*` reload commands, and orders everything so
changes apply cleanly on every run.

---

## What this module manages

Depending on how you use it, the module can manage these things:

| Element | Default location | Puppet representation |
| --- | --- | --- |
| Unit files | `/etc/systemd/system/*.unit` | `systemd::unit_file`, `systemd::manage_unit` |
| Unit drop-ins | `<unit>.d/*.conf` | `systemd::dropin_file`, `systemd::manage_dropin` |
| Daemon config drop-ins | `<daemon>.conf.d/*.conf` | `systemd::<daemon>::manage_dropin` |
| Kernel modules | `/etc/modules-load.d/*.conf` | `systemd::modules_load` |
| System users | `/etc/sysusers.d/*.conf` | `systemd::sysuser` |
| tmpfiles.d entries | `/etc/tmpfiles.d/*.conf` | `systemd::tmpfile` |
| Timers + services | `/etc/systemd/system/*.timer` | `systemd::timer`, `systemd::timer_wrapper` |
| networkd files | `/etc/systemd/network/*` | `systemd::network`, `systemd::networkd::interface` |
| User services | per-user `systemd --user` | `systemd::user_service` |
| Bundled daemons | per daemon | the `systemd` class parameters |

All of these can also be declared through Hiera hashes on the main `systemd`
class (see [The systemd class](#the-systemd-class--tuning-what-is-managed)).

---

## Getting started

The smallest useful configuration declares a single unit file and lets the
module handle the file, the ordering, and the reload:

```puppet
systemd::unit_file { 'foo.service':
  source => "puppet:///modules/${module_name}/foo.service",
}

 ~> service { 'foo':
  ensure => running,
}
```

To actually install and run a service you write, use `systemd::manage_unit`,
which generates the unit from section hashes so you never hand-edit INI:

```puppet
systemd::manage_unit { 'myrunner.service':
  unit_entry    => {
    Description => 'My great service',
  },
  service_entry => {
    Type      => oneshot,
    ExecStart => '/usr/bin/doit.sh',
  },
  install_entry => {
    WantedBy => 'multi-user.target',
  },
  enable => true,
  active => true,
}
```

After the next Puppet run the file exists at
`/etc/systemd/system/myrunner.service` with a `# Deployed with puppet` banner,
systemd has been reloaded, and the service is enabled and running.

### The equivalent in Hiera

You do not have to touch a manifest. The same result is obtained by setting the
`manage_units` class parameter, which accepts a hash and expands it with
`create_resources` semantics:

```yaml
# conf/hiera/common.yaml
lookup_options:
  systemd::manage_units:
    merge: hash

systemd::manage_units:
  myrunner.service:
    unit_entry:
      Description: My great service
    service_entry:
      Type: oneshot
      ExecStart: /usr/bin/doit.sh
    install_entry:
      WantedBy: multi-user.target
```

Any valid `systemd::manage_unit` manifest can be written this way, as can
`systemd::manage_dropins`, `systemd::dropin_files`, `systemd::timers`,
`systemd::unit_files`, `systemd::tmpfiles`, and `systemd::networks`.

---

## The systemd class -- tuning what is managed

`class systemd (...)` is the entry point. Pulling it in (which every defined
type does automatically via `include systemd`) installs any required sub-package
and wires up the reload machinery. The most commonly used parameters:

| Parameter | Default | Purpose |
| --- | --- | --- |
| `manage_resolved` | `false` | Manage `systemd-resolved` and `/etc/resolv.conf`. |
| `manage_networkd` | `false` | Manage `systemd-networkd` and `networkd.conf`. |
| `manage_timesyncd` | `false` | Manage `systemd-timesyncd` and `timesyncd.conf`. |
| `manage_journald` | `true` | Manage `systemd-journald` and `journald.conf`. |
| `manage_udevd` | `false` | Manage `systemd-udevd` and `udev.conf`. |
| `manage_logind` | `false` | Manage `systemd-logind` and `logind.conf`. |
| `manage_coredump` | `false` | Manage `systemd-coredump` and `coredump.conf`. |
| `manage_oomd` | `false` | Manage `systemd-oomd` and `oomd.conf`. |
| `manage_sleep` | `false` | Manage `systemd-sleep` and `sleep.conf`. |
| `manage_system_conf` | `false` | Manage `[Manager]` keys in `system.conf`. |
| `manage_user_conf` | `false` | Manage `[Manager]` keys in `user.conf`. |
| `manage_accounting` | `false` | Enable per-unit accounting (network/IO/CPU). |
| `purge_dropin_dirs` | `true` | Remove drop-in files the module does not manage. |
| `default_target` | `undef` | Set the default boot target (unmanaged if undef). |
| `manage_units` | `{}` | Hash of `systemd::manage_unit` entries. |
| `manage_dropins` | `{}` | Hash of `systemd::manage_dropin` entries. |
| `dropin_files` | `{}` | Hash of `systemd::dropin_file` entries. |
| `timers` | `{}` | Hash of `systemd::timer` entries. |
| `unit_files` | `{}` | Hash of `systemd::unit_file` entries. |
| `tmpfiles` | `{}` | Hash of `systemd::tmpfile` entries. |
| `networks` | `{}` | Hash of `systemd::network` entries. |
| `purge_units` | `false` | `true`, or an array of paths, to purge old units. |

Per-daemon configuration is supplied through `*_settings` hashes (for example
`journald_settings`, `logind_settings`, `coredump_settings`, `oomd_settings`,
`sleep_settings`, `system_settings`, `user_settings`) and, where relevant, a set
of dedicated parameters (DNS/NTP for resolved/timesyncd, udev knobs, etc.). The
full parameter list is in [REFERENCE.md](REFERENCE.md).

---

## The defined types

### Which resource do I use?

Use this table to pick the right resource.

| What you want to put... | Use... |
| --- | --- |
| A complete unit file you ship as a template or file | `systemd::unit_file` |
| A unit you describe as key/value sections (no hand-written INI) | `systemd::manage_unit` |
| A drop-in file on top of an existing unit, from a template | `systemd::dropin_file` |
| A drop-in file on top of an existing unit, from key/value sections | `systemd::manage_dropin` |
| A `[Section]` config for one of systemd's bundled daemons | `systemd::<daemon>::manage_dropin` |
| A kernel module to load at boot | `systemd::modules_load` |
| A `sysusers.d` entry (create a user/group/mode) | `systemd::sysuser` |
| A `tmpfiles.d` entry | `systemd::tmpfile` |
| A timer (and optional service) | `systemd::timer` or `systemd::timer_wrapper` |
| A `systemd-networkd` file | `systemd::network` or `systemd::networkd::interface` |
| A unit under a `systemd --user` instance | `systemd::user_service` |

### systemd::unit_file -- deploy a unit file

`systemd::unit_file` deploys a unit file. Provide `content` or `source` (they
are mutually exclusive). The file is written as mode `0444` and owned by root.

```puppet
systemd::unit_file { 'foo.service':
  content => file("${module_name}/foo.service"),
  enable  => true,
  active  => true,
}
```

When `enable` or `active` is set, the module also declares a `service` resource
and orders the file change ahead of it. Use `enable => 'mask'` to symlink the
unit to `/dev/null`, or `ensure => 'absent'` to remove the unit and its
enablement link.

A template unit (a name containing `@`) can be enabled for a concrete instance
through an ordinary `service` resource:

```puppet
systemd::unit_file { 'foo@.service':
  content => file("${module_name}/foo@.service"),
}

service { 'foo@bar.service':
  ensure => running,
  enable => true,
}
```

### systemd::manage_unit -- generate a unit from parameters

`systemd::manage_unit` generates a unit file from section hashes. Each `*_entry`
maps to a section:

- `unit_entry` -> `[Unit]`
- `service_entry` -> `[Service]`
- `install_entry` -> `[Install]`
- `timer_entry` -> `[Timer]`
- `path_entry` -> `[Path]`
- `socket_entry` -> `[Socket]`
- `automount_entry` -> `[Automount]`
- `mount_entry` -> `[Mount]`
- `swap_entry` -> `[Swap]`
- `slice_entry` -> `[Slice]`

```puppet
systemd::manage_unit { 'arcd.socket':
  ensure        => present,
  unit_entry    => { Description => 'arcd.socket' },
  socket_entry  => {
    ListenStream => 4241,
    Accept       => true,
  },
  install_entry => { WantedBy => 'sockets.target' },
}

 systemd::manage_unit { 'arcd@.service':
  ensure        => present,
  enable        => true,
  service_entry => {
    Type          => simple,
    ExecStart     => '/usr/sbin/arcd /usr/libexec/arcd/arcd.pl',
    StandardInput => 'socket',
  },
}
```

For service units `service_entry` is required, unless `enable => 'mask'` or
`ensure => 'absent'`. The resource title is the unit name and must carry a valid
extension such as `.service`, `.timer`, or `.mount`.

### systemd::dropin_file / systemd::manage_dropin -- extend a unit

Drop-ins extend or override a unit without editing the unit itself.

`systemd::dropin_file` deploys a file you already have, onto `<unit>.d/`:

```puppet
systemd::dropin_file { 'foo.conf':
  unit   => 'foo.service',
  source => "puppet:///modules/${module_name}/foo.conf",
}

 ~> service { 'foo':
  ensure => running,
}
```

`systemd::manage_dropin` generates a drop-in from sections instead:

```puppet
systemd::manage_dropin { 'myconf.conf':
  ensure        => present,
  unit          => 'myservice.service',
  service_entry => {
    LimitNOFILE => 8192,
    LimitNPROC  => 16384,
  },
}
```

Both create the `<unit>.d` directory, notify the service on change, and reload
systemd. Add `comments => ['...', ...]` to prefix the generated file with a
comment block. The `manage_dropin` variants also support `path_entry`,
`socket_entry`, `mount_entry`, `swap_entry`, `automount_entry`, `slice_entry`,
and `manager_entry` (for `system.conf`/`user.conf`).

### Strongly-typed daemon config drop-ins

There is a set of general-purpose `.d` config drop-ins for systemd's bundled
daemons. Each daemon has a matching class with a strongly typed settings hash so
that only valid keys are accepted and the file is rendered from the correct
`[Section]`:

| Daemon | Section class | `[Section]` | Default drop-in path |
| --- | --- | --- | --- |
| resolved | `systemd::resolved::manage_dropin` | `[Resolve]` | `/etc/systemd/resolved.conf.d` |
| timesyncd | `systemd::timesyncd::manage_dropin` | `[Time]` | `/etc/systemd/timesyncd.conf.d` |
| journald | `systemd::journald::manage_dropin` | `[Journal]` | `/etc/systemd/journald.conf.d` |
| logind | `systemd::logind::manage_dropin` | `[Login]` | `/etc/systemd/logind.conf.d` |
| oomd | `systemd::oomd::manage_dropin` | `[OOM]` | `/etc/systemd/oomd.conf.d` |
| coredump | `systemd::coredump::manage_dropin` | `[Coredump]` | `/etc/systemd/coredump.conf.d` |
| sleep | `systemd::sleep::manage_dropin` | `[Sleep]` | `/etc/systemd/sleep.conf.d` |
| system.conf | `systemd::system::manage_dropin` | `[Manager]` | `/etc/systemd/system.conf.d` |
| user.conf | `systemd::user::manage_dropin` | `[Manager]` | `/etc/systemd/user.conf.d` |

Each has a paired `dropin_file` variant that accepts arbitrary content when you
want raw control instead of type validation.

```puppet
systemd::journald::manage_dropin { 'storage.conf':
  journal_entry => {
    Storage: persistent,
    // A value can be removed by pairing it with an absent ensure:
    Audit: { ensure => absent },
  },
  comments => ['Tune journald storage'],
}
```

Notes:

- The settings hash is validated against a per-daemon type (for example
  `Systemd::JournaldSettings`); only valid keys and value shapes are accepted.
- A value written as a hash with `ensure => 'absent'` is stripped from the file,
  which is the supported way to remove a key that another tool may have added.
- `comments => [...]` writes a `# managed with puppet` banner plus your lines.
- These drop-ins require the daemon to be managed: set the matching
  `manage_<daemon>` flag (for example `manage_journald => true`) on the `systemd`
  class, otherwise the resource fails to compile. The `system` and `user`
  drop-ins call `daemon-reexec` instead of restarting a service, because
  `system.conf`/`user.conf` changes need it.
- A raw-content `dropin_file` variant exists for every daemon in the table.

### systemd::modules_load -- load kernel modules

`systemd::modules_load` writes a file in `modules-load.d` and notifies
`systemd-modules-load.service`:

```puppet
systemd::modules_load { 'ipi.conf':
  content => "ipi\n",
}
```

### systemd::sysuser -- create system users

`systemd::sysuser` writes a `sysusers.d` file and runs `systemd-sysusers`
afterwards:

```puppet
systemd::sysuser { 'plato':
  content => 'u plato - "Be Kind"',
}
```

The `.conf` extension is optional in the title; the value is literal
`sysusers.d` syntax. Set `ensure => 'absent'` to remove the file.

### systemd::tmpfile -- manage tmpfiles.d entries

Let the module manage the file and trigger `systemd-tmpfiles`:

```puppet
systemd::tmpfile { 'foo.conf':
  source => "puppet:///modules/${module_name}/foo.conf",
}
```

Or manage the file yourself and trigger the update via the `systemd::tmpfiles`
class:

```puppet
include systemd::tmpfiles

file { '/etc/tmpfiles.d/foo.conf':
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0444',
  source  => "puppet:///modules/${module_name}/foo.conf",
}

 ~> Class['systemd::tmpfiles']
```

### systemd::timer / systemd::timer_wrapper -- schedule tasks

`systemd::timer` creates a timer unit and, optionally, the service it triggers.
With `enable`/`active` set the module also manages the `*.timer` service.

```puppet
systemd::timer { 'runoften.timer':
  timer_source   => "puppet:///modules/${module_name}/runoften.timer",
  service_source => "puppet:///modules/${module_name}/runoften.service",
  active         => true,
  enable         => true,
}
```

Prefer a cron-like interface? `systemd::timer_wrapper` builds the timer and
service for you:

```puppet
systemd::timer_wrapper { 'my_cleanup':
  ensure      => present,
  command     => '/usr/bin/my_cleanup.sh',
  on_calendar => '@hourly',
}
```

`systemd::timer` accepts either `*_source` (a `File`-compatible source) or
`*_content` for the timer and service; if neither `service_source` nor
`service_content` is given, no companion service unit is created. The service
unit name defaults to the timer name with the suffix swapped, override it with
`service_unit`.

### systemd::network / systemd::networkd::interface -- network configuration

`systemd-networkd` manages network configuration. Deploy a file directly:

```puppet
systemd::network { 'eth0.network':
  source          => "puppet:///modules/${module_name}/eth0.network",
  restart_service => true,
}
```

Or use the structured `systemd::networkd::interface` define, which writes
`/etc/systemd/network/50-static.network`:

```puppet
systemd::networkd::interface { 'static-enp2s0':
  type            => 'network',
  interface       => {
    filename => '50-static',
    network  => {
      Match   => { Name => 'enp2s0' },
      Network => { Address => '192.168.0.15/24' },
    },
  },
  network_profile => {
    Network => { Gateway => '192.168.0.1' },
  },
}
```

Many `/etc/systemd/networkd.conf` `[Network]` settings are also available
directly on the main `systemd` class (for example `ipv4_forwarding`,
`ipv6_forwarding`, and `manage_foreign_routes`).

### systemd::user_service -- manage user services

`systemd::user_service` acts on units under a `systemd --user` instance. Provide
either a `user` or `global`:

```puppet
# Enable a service for one user:
systemd::user_service { 'podman-auto-update.timer':
  ensure => true,
  enable => true,
  user   => 'steve',
}

# Disable a service for all users:
systemd::user_service { 'systemd-tmpfiles-clean.timer':
  enable => false,
  global => true,
}
```

### systemd::purge_units -- remove unmanaged units

When you remove a `systemd::manage_unit` definition, its file stays on disk by
default. To remove the files that `systemd::manage_unit` previously wrote,
enable purging. Only files whose first line is the `# Deployed with puppet`
header are removed; hand-written units and enablement symlinks are never
touched.

```puppet
include systemd::purge_units

# Or, limited to custom paths, unit types, and without a daemon reload:
class { 'systemd::purge_units':
  paths         => ['/custom/path'],
  unit_types    => ['service', 'timer'],
  daemon_reload => false,
}
```

Trigger it from Hiera with `systemd::purge_units => true`, or for finer control
declare the `systemd_purge_units` type directly.

### systemd::daemon_reload / systemd::daemon_reexec -- reload systemd

When you need explicit control over the reload, use `systemd::daemon_reload`
(for the system manager, or a `systemd --user` instance via `user =>`) and
`systemd::daemon_reexec` (required for `system.conf`/`user.conf` changes):

```puppet
notify { 'fake change':
  notify => Systemd::Daemon_reload['special'],
}

systemd::daemon_reload { 'special': }
```

---

## Advanced configuration

### Two ways to configure a daemon

Each managed daemon can be configured in two complementary ways:

1. **The main config file** (for example `/etc/systemd/journald.conf`) is managed
   through the class `*_settings` hash and `*_use_etc_conf` (for example
   `journald_use_etc_conf`). This writes the file in place with `inifile`.
2. **A `.d` drop-in** (for example
   `/etc/systemd/journald.conf.d/10-custom.conf`) is managed through the
   `systemd::<daemon>::manage_dropin` / `dropin_file` types described above.

Both may coexist; systemd merges drop-ins on top of the main file. Prefer
drop-ins when you want to layer small overrides, or when you need to remove a
key another tool added (see the `ensure => 'absent'` value form).

### Daemon reload behaviour

systemd caches unit files, so configuration changes require a reload. Since
Puppet 6.1.0 ([PUP-3483](https://tickets.puppetlabs.com/browse/PUP-3483)) the
`service` resource calls
`systemctl show <unit> --property=NeedDaemonReload` to decide whether a reload
is needed, so most resources reload automatically.

`system.conf`/`user.conf` changes need `daemon-reexec` (not just
`daemon-reload`); the module performs it automatically whenever a
`systemd::system::*` or `systemd::user::*` drop-in changes. Explicit control is
available via `systemd::daemon_reload` and `systemd::daemon_reexec`.

### systemd-escape on the agent

`systemd::escape` escapes strings at catalog compile time, mirroring
`systemd-escape` without spawning a command:

```puppet
systemd::escape('foo::bar/')   # 'foo::bar-'
systemd::escape('/mnt/foobar', true)  # 'mnt-foobar' (path escaping)
```

`systemd::systemd_escape` runs the real `systemd-escape` on the agent, so it must
be used as a deferred function:

```puppet
$result = Deferred('systemd::systemd_escape', ["foo::bar"])
```

### Query units with Bolt

The `systemd::systemctl_show` task returns structured output, unlike the plain
`service` task:

```puppet
bolt task run systemd::systemctl_show unit_name=puppet.service -t controller-0

  {
    "MainPID": "686",
    "LoadState": "loaded",
    "ActiveState": "active",
    "SubState": "running",
    "UnitFileState": "enabled"
  }
```

---

## Limitations and deprecations

- The `systemd` class is private in spirit: declare daemon state through its
  `manage_*` parameters rather than including `systemd::journald`, etc. directly.
- `systemd::service_limits` was removed; use `systemd::manage_dropin` with a
  `service_entry` instead.
- `systemd::unit_file` no longer accepts `ensure => file` or the
  `hasrestart`/`hasstatus` parameters.
- `systemd::systemd_escape` must be invoked as a deferred function.
- Daemon `*_dropin` and `*_manage_dropin` resources require the matching
  `manage_<daemon>` flag on the `systemd` class.
- Setting `networkd_ensure => 'stopped'` may only be transient on systemd 260+
  (a socket can restart the service almost immediately).
- See [CHANGELOG.md](CHANGELOG.md) for the full list of changes per release.

---

## Development

The full, machine-generated API reference is in
[REFERENCE.md](REFERENCE.md), covering every class, defined type, resource type,
function, data type, and the Bolt task, including all parameters and their
defaults.

Development follows the Vox Pupuli conventions shared across its modules:

- Unit tests use rspec-puppet (`spec/`); run with `rake spec`.
- Acceptance tests (`spec/acceptance`) provision nodes via
  [voxpupuli-acceptance](https://github.com/voxpupuli/test) (Beaker-based).
- CI runs on GitHub Actions (`.github/workflows/`).

For the module's own metadata -- its dependencies, supported operating systems,
and version requirements -- see
[metadata.json](metadata.json).

---

## Support and authors

For issues, feature requests, and documentation, see the project's home pages:

- GitHub: https://github.com/voxpupuli/puppet-systemd
- Puppet Forge: https://forge.puppet.com/puppet/systemd

Authored and maintained by Vox Pupuli. See [LICENSE](LICENSE) for the
Apache-2.0 terms.
