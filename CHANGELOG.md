# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v7.1.0](https://github.com/voxpupuli/puppet-systemd/tree/v7.1.0) (2024-06-03)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v7.0.0...v7.1.0)

**Implemented enhancements:**

- add MemoryDenyWriteExecute to Systemd::Unit::Service type [\#465](https://github.com/voxpupuli/puppet-systemd/pull/465) ([TheMeier](https://github.com/TheMeier))
- Allow setting a specific package name for systemd-oomd [\#464](https://github.com/voxpupuli/puppet-systemd/pull/464) ([jcpunk](https://github.com/jcpunk))
- Add support for timezone and hardware clock [\#462](https://github.com/voxpupuli/puppet-systemd/pull/462) ([jcpunk](https://github.com/jcpunk))
- fix typo in service\_limits deprecation message [\#460](https://github.com/voxpupuli/puppet-systemd/pull/460) ([saz](https://github.com/saz))
- fix: refresh service only based on drop-in file changes [\#406](https://github.com/voxpupuli/puppet-systemd/pull/406) ([shieldwed](https://github.com/shieldwed))

**Merged pull requests:**

- Update README to reflect service\_limits is deprecated [\#461](https://github.com/voxpupuli/puppet-systemd/pull/461) ([ekohl](https://github.com/ekohl))

## [v7.0.0](https://github.com/voxpupuli/puppet-systemd/tree/v7.0.0) (2024-04-26)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.6.0...v7.0.0)

**Breaking changes:**

- remove `systemd::escape` usage for `timer_wrapper` [\#452](https://github.com/voxpupuli/puppet-systemd/pull/452) ([TheMeier](https://github.com/TheMeier))
- Drop EoL Debian 10 support [\#448](https://github.com/voxpupuli/puppet-systemd/pull/448) ([bastelfreak](https://github.com/bastelfreak))
- Use Stdlib::CreateResources type for hiera expansions [\#438](https://github.com/voxpupuli/puppet-systemd/pull/438) ([traylenator](https://github.com/traylenator))
- Deprecate `systemd::service_limits` [\#437](https://github.com/voxpupuli/puppet-systemd/pull/437) ([traylenator](https://github.com/traylenator))
- Don't allow ensure=file anymore for systemd::unit\_file [\#434](https://github.com/voxpupuli/puppet-systemd/pull/434) ([baurmatt](https://github.com/baurmatt))

**Implemented enhancements:**

- Add `NetworkNamespacePath` to unit service [\#440](https://github.com/voxpupuli/puppet-systemd/issues/440)
- Add hiera-friendly option to manage dropins [\#435](https://github.com/voxpupuli/puppet-systemd/issues/435)
- Manage units running under `systemd --user` instance [\#446](https://github.com/voxpupuli/puppet-systemd/pull/446) ([traylenator](https://github.com/traylenator))
- New parameters to manage systemd-nspawn [\#444](https://github.com/voxpupuli/puppet-systemd/pull/444) ([traylenator](https://github.com/traylenator))
- Support reload of instances of systemd --user [\#443](https://github.com/voxpupuli/puppet-systemd/pull/443) ([traylenator](https://github.com/traylenator))
- Add NetworkNamespacePath as a valid unit service configuration [\#441](https://github.com/voxpupuli/puppet-systemd/pull/441) ([Valantin](https://github.com/Valantin))
- Create manage\_unit, manage\_dropin types from hiera [\#436](https://github.com/voxpupuli/puppet-systemd/pull/436) ([traylenator](https://github.com/traylenator))
- Make service restart upon unit file change optional [\#433](https://github.com/voxpupuli/puppet-systemd/pull/433) ([schustersv](https://github.com/schustersv))
- remove resolved settings from config when changed to `absent` [\#429](https://github.com/voxpupuli/puppet-systemd/pull/429) ([TheMeier](https://github.com/TheMeier))
- Add parameter to manage /etc/udev/rules.d directory [\#428](https://github.com/voxpupuli/puppet-systemd/pull/428) ([TheMeier](https://github.com/TheMeier))
- `systemd::unit_file`: Ensure link gets removed on `ensure => absent` [\#405](https://github.com/voxpupuli/puppet-systemd/pull/405) ([baurmatt](https://github.com/baurmatt))

**Fixed bugs:**

- IODeviceWeight, IOReadIOPSMax, .. do not work in systemd::manage\_unit or systemd::dropin\_file [\#424](https://github.com/voxpupuli/puppet-systemd/issues/424)
- Correctly interpolate variables in `service_limits` [\#449](https://github.com/voxpupuli/puppet-systemd/pull/449) ([ekohl](https://github.com/ekohl))
- Correct typing for IOReadIOPSMax, IOWriteIOPSMax,... in systemd::manage\_dropin [\#430](https://github.com/voxpupuli/puppet-systemd/pull/430) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- Service not enabled on systemd::timer [\#391](https://github.com/voxpupuli/puppet-systemd/issues/391)
- create systemd::path [\#370](https://github.com/voxpupuli/puppet-systemd/issues/370)
- create services/timers for users [\#328](https://github.com/voxpupuli/puppet-systemd/issues/328)

**Merged pull requests:**

- Fix typo [\#455](https://github.com/voxpupuli/puppet-systemd/pull/455) ([deric](https://github.com/deric))
- Add test case for interpolation bug in name of used types [\#450](https://github.com/voxpupuli/puppet-systemd/pull/450) ([traylenator](https://github.com/traylenator))
- `init`: `service_limits` param: don't refer to `create_resources` [\#439](https://github.com/voxpupuli/puppet-systemd/pull/439) ([kenyon](https://github.com/kenyon))

## [v6.6.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.6.0) (2024-03-08)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.5.0...v6.6.0)

**Implemented enhancements:**

- Add bolt task to return unit state in a more parsable way [\#426](https://github.com/voxpupuli/puppet-systemd/pull/426) ([rwaffen](https://github.com/rwaffen))

## [v6.5.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.5.0) (2024-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.4.0...v6.5.0)

**Implemented enhancements:**

- Add possibility to setup limits for user sessions [\#417](https://github.com/voxpupuli/puppet-systemd/issues/417)
- add a cron-like systemd::timer interface [\#374](https://github.com/voxpupuli/puppet-systemd/issues/374)
- Use Systemd::Unit::Amount, Percent and AmountOrPercent [\#422](https://github.com/voxpupuli/puppet-systemd/pull/422) ([traylenator](https://github.com/traylenator))
- Support `[Slice]` in manage\_unit and manage\_dropin [\#420](https://github.com/voxpupuli/puppet-systemd/pull/420) ([traylenator](https://github.com/traylenator))
- feat: add a cron like wrapper for timers [\#419](https://github.com/voxpupuli/puppet-systemd/pull/419) ([TheMeier](https://github.com/TheMeier))

**Fixed bugs:**

- Allow CPUQuota to be greater than 100% [\#423](https://github.com/voxpupuli/puppet-systemd/pull/423) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Rename daemon\_reload.rb to daemon\_reload\_spec.rb [\#418](https://github.com/voxpupuli/puppet-systemd/pull/418) ([TheMeier](https://github.com/TheMeier))
- manage\_unit: correct minor mistakes in examples [\#415](https://github.com/voxpupuli/puppet-systemd/pull/415) ([zbentley](https://github.com/zbentley))

## [v6.4.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.4.0) (2024-02-26)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.3.0...v6.4.0)

**Implemented enhancements:**

- Support `StartLimitIntervalSec` and  `StartLimitBurst` [\#412](https://github.com/voxpupuli/puppet-systemd/pull/412) ([traylenator](https://github.com/traylenator))
- unit type: add `ConditionPathIsMountPoint` [\#408](https://github.com/voxpupuli/puppet-systemd/pull/408) ([fragfutter](https://github.com/fragfutter))
- Allow percent \(%\) character in unit names. [\#401](https://github.com/voxpupuli/puppet-systemd/pull/401) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- Support multiple Environment Settings [\#409](https://github.com/voxpupuli/puppet-systemd/pull/409) ([traylenator](https://github.com/traylenator))
- Deleting duplicate Key entries in types/unit/service.pp [\#407](https://github.com/voxpupuli/puppet-systemd/pull/407) ([C24-AK](https://github.com/C24-AK))
- systemd::cache = false result was vague. [\#403](https://github.com/voxpupuli/puppet-systemd/pull/403) ([traylenator](https://github.com/traylenator))

## [v6.3.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.3.0) (2023-12-06)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.2.0...v6.3.0)

**Implemented enhancements:**

- Add some missing `Unit` options [\#396](https://github.com/voxpupuli/puppet-systemd/pull/396) ([gcoxmoz](https://github.com/gcoxmoz))

**Fixed bugs:**

- Invalid option `MaxFree` in `cordedump.conf` [\#398](https://github.com/voxpupuli/puppet-systemd/issues/398)
- Correct coredump parameter from `MaxFree` to `KeepFree` [\#399](https://github.com/voxpupuli/puppet-systemd/pull/399) ([traylenator](https://github.com/traylenator))

## [v6.2.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.2.0) (2023-11-21)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.1.0...v6.2.0)

**Implemented enhancements:**

- Add `UMask` to `Systemd::Unit::Service` [\#393](https://github.com/voxpupuli/puppet-systemd/pull/393) ([griggi-ws](https://github.com/griggi-ws))
- Add `StateDirectory` to `Systemd::Unit::Service` [\#392](https://github.com/voxpupuli/puppet-systemd/pull/392) ([henrixh](https://github.com/henrixh))

## [v6.1.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.1.0) (2023-10-30)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Add Debian 12 support [\#386](https://github.com/voxpupuli/puppet-systemd/pull/386) ([bastelfreak](https://github.com/bastelfreak))
- Add OracleLinux 9 support [\#385](https://github.com/voxpupuli/puppet-systemd/pull/385) ([bastelfreak](https://github.com/bastelfreak))
- Install systemd-networkd package, if any [\#380](https://github.com/voxpupuli/puppet-systemd/pull/380) ([ekohl](https://github.com/ekohl))
- Add more security related parameters to service [\#379](https://github.com/voxpupuli/puppet-systemd/pull/379) ([lkck24](https://github.com/lkck24))
- only accept socket\_entry for socket units [\#376](https://github.com/voxpupuli/puppet-systemd/pull/376) ([evgeni](https://github.com/evgeni))
- Implement DNSStubListenerExtra for resolved.conf [\#371](https://github.com/voxpupuli/puppet-systemd/pull/371) ([ekohl](https://github.com/ekohl))
- Support Debian 12 [\#357](https://github.com/voxpupuli/puppet-systemd/pull/357) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Drop OracleLinux 7 from metadata.json [\#384](https://github.com/voxpupuli/puppet-systemd/pull/384) ([bastelfreak](https://github.com/bastelfreak))

## [v6.0.0](https://github.com/voxpupuli/puppet-systemd/tree/v6.0.0) (2023-09-04)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v5.2.0...v6.0.0)

**Breaking changes:**

- Drop Ubuntu 18.04 which went out of standard support in May 2023 [\#365](https://github.com/voxpupuli/puppet-systemd/pull/365) ([simondeziel](https://github.com/simondeziel))

**Implemented enhancements:**

- Add ability to manage StopIdleSessionSec in logind.conf [\#369](https://github.com/voxpupuli/puppet-systemd/pull/369) ([jasonknudsen](https://github.com/jasonknudsen))
- add PrivateTmp and RuntimeDirectory [\#368](https://github.com/voxpupuli/puppet-systemd/pull/368) ([oOHenry](https://github.com/oOHenry))
- add ability to set limits with the systemd::manage\_unit resource [\#367](https://github.com/voxpupuli/puppet-systemd/pull/367) ([oOHenry](https://github.com/oOHenry))
- Remove support for Fedora 36 and add support for Fedora 38 [\#366](https://github.com/voxpupuli/puppet-systemd/pull/366) ([simondeziel](https://github.com/simondeziel))
- Add Puppet 8 support [\#359](https://github.com/voxpupuli/puppet-systemd/pull/359) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- fix socket service example syntax [\#375](https://github.com/voxpupuli/puppet-systemd/pull/375) ([evgeni](https://github.com/evgeni))

## [v5.2.0](https://github.com/voxpupuli/puppet-systemd/tree/v5.2.0) (2023-07-13)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v5.1.0...v5.2.0)

**Implemented enhancements:**

- Missing WorkingDirectory parameter on Systemd::Unit::Service [\#320](https://github.com/voxpupuli/puppet-systemd/issues/320)
- Nice, IOSchedulingPriority and IOSchedulingClass [\#363](https://github.com/voxpupuli/puppet-systemd/pull/363) ([traylenator](https://github.com/traylenator))
- allow to set StandardInput on service unit [\#362](https://github.com/voxpupuli/puppet-systemd/pull/362) ([oOHenry](https://github.com/oOHenry))
- Allow SupplementaryGroups and DynamicUser [\#358](https://github.com/voxpupuli/puppet-systemd/pull/358) ([traylenator](https://github.com/traylenator))
- Allow LogLevelMax to be set in \[Service\] [\#356](https://github.com/voxpupuli/puppet-systemd/pull/356) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- Correct syntax in manage\_unit socket example [\#354](https://github.com/voxpupuli/puppet-systemd/pull/354) ([ekohl](https://github.com/ekohl))

## [v5.1.0](https://github.com/voxpupuli/puppet-systemd/tree/v5.1.0) (2023-06-15)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v5.0.0...v5.1.0)

**Implemented enhancements:**

- Support StandardOutput, StandardError and RequiresMountsFor. [\#353](https://github.com/voxpupuli/puppet-systemd/pull/353) ([traylenator](https://github.com/traylenator))
- Allow WorkingDirectory to be specified in \[Service\] [\#352](https://github.com/voxpupuli/puppet-systemd/pull/352) ([traylenator](https://github.com/traylenator))
- Socket support for manage unit and dropin [\#350](https://github.com/voxpupuli/puppet-systemd/pull/350) ([traylenator](https://github.com/traylenator))
- Allow puppetlabs-stdlib 9.x [\#349](https://github.com/voxpupuli/puppet-systemd/pull/349) ([smortex](https://github.com/smortex))
- No insistence on unit\_entry ever or service\_entry with absent manage\_unit [\#345](https://github.com/voxpupuli/puppet-systemd/pull/345) ([traylenator](https://github.com/traylenator))
- Add comment in manage\_unit deployed files [\#333](https://github.com/voxpupuli/puppet-systemd/pull/333) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- Feature Request for socket unit files [\#348](https://github.com/voxpupuli/puppet-systemd/issues/348)
- Module require an old version of puppetlabs-inifile [\#343](https://github.com/voxpupuli/puppet-systemd/issues/343)

## [v5.0.0](https://github.com/voxpupuli/puppet-systemd/tree/v5.0.0) (2023-06-01)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v4.2.0...v5.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#342](https://github.com/voxpupuli/puppet-systemd/pull/342) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Refactor unit template [\#344](https://github.com/voxpupuli/puppet-systemd/pull/344) ([traylenator](https://github.com/traylenator))
- Allow LimitCORE in \[Service\] for manage\_unit/dropin [\#341](https://github.com/voxpupuli/puppet-systemd/pull/341) ([traylenator](https://github.com/traylenator))
- Allow SyslogIdentifier, KillMode and KillSignal to \[service\] section [\#339](https://github.com/voxpupuli/puppet-systemd/pull/339) ([traylenator](https://github.com/traylenator))
- Addition of path directives to manage\_unit/dropin [\#337](https://github.com/voxpupuli/puppet-systemd/pull/337) ([traylenator](https://github.com/traylenator))
- Addition of timer directives to manage\_unit and manage\_dropin [\#335](https://github.com/voxpupuli/puppet-systemd/pull/335) ([traylenator](https://github.com/traylenator))
- Allow DefaultDependencies to be set in \[Unit\] section [\#334](https://github.com/voxpupuli/puppet-systemd/pull/334) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- Increase inifile version in metadata to \< 7.0.0 [\#336](https://github.com/voxpupuli/puppet-systemd/issues/336)

**Merged pull requests:**

- Increase inifile dependency upper version to \< 7.0.0 [\#338](https://github.com/voxpupuli/puppet-systemd/pull/338) ([canihavethisone](https://github.com/canihavethisone))
- Group spec expectations in a single example [\#331](https://github.com/voxpupuli/puppet-systemd/pull/331) ([ekohl](https://github.com/ekohl))

## [v4.2.0](https://github.com/voxpupuli/puppet-systemd/tree/v4.2.0) (2023-04-18)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v4.1.0...v4.2.0)

**Implemented enhancements:**

- Add AmbientCapabilities to Systemd::Unit::Service [\#329](https://github.com/voxpupuli/puppet-systemd/pull/329) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Stick to the Puppet language style guide in examples [\#327](https://github.com/voxpupuli/puppet-systemd/pull/327) ([smortex](https://github.com/smortex))
- Fix `manage_unit` example in README.md [\#326](https://github.com/voxpupuli/puppet-systemd/pull/326) ([Enucatl](https://github.com/Enucatl))

## [v4.1.0](https://github.com/voxpupuli/puppet-systemd/tree/v4.1.0) (2023-03-31)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v4.0.1...v4.1.0)

**Implemented enhancements:**

- Expand managed unit entry with User, Group + EnvironmentFile Array [\#323](https://github.com/voxpupuli/puppet-systemd/pull/323) ([ekohl](https://github.com/ekohl))
- Add timer\_entry to manage\_{dropin,unit} [\#322](https://github.com/voxpupuli/puppet-systemd/pull/322) ([ekohl](https://github.com/ekohl))
- add support for {AlmaLinux,Rocky} {8,9} [\#319](https://github.com/voxpupuli/puppet-systemd/pull/319) ([jhoblitt](https://github.com/jhoblitt))

**Fixed bugs:**

- Systemd::Unit::Service: missing User and Group [\#299](https://github.com/voxpupuli/puppet-systemd/issues/299)

## [v4.0.1](https://github.com/voxpupuli/puppet-systemd/tree/v4.0.1) (2023-01-31)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- Revert udevadm and udev facts from \#292 [\#316](https://github.com/voxpupuli/puppet-systemd/pull/316) ([jhoblitt](https://github.com/jhoblitt))
- systemd::timer: fix before's argument to use the proper syntax [\#315](https://github.com/voxpupuli/puppet-systemd/pull/315) ([simondeziel](https://github.com/simondeziel))

## [v4.0.0](https://github.com/voxpupuli/puppet-systemd/tree/v4.0.0) (2023-01-27)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.10.0...v4.0.0)

**Breaking changes:**

- drop support for fedora 30 & 31 \(EOL\) [\#310](https://github.com/voxpupuli/puppet-systemd/pull/310) ([jhoblitt](https://github.com/jhoblitt))
- drop support for ubuntu 16.04 \(EOL\) [\#308](https://github.com/voxpupuli/puppet-systemd/pull/308) ([jhoblitt](https://github.com/jhoblitt))
- drop debian 9 support \(EOL\) [\#307](https://github.com/voxpupuli/puppet-systemd/pull/307) ([jhoblitt](https://github.com/jhoblitt))
- Remove debian 8 support [\#305](https://github.com/voxpupuli/puppet-systemd/pull/305) ([traylenator](https://github.com/traylenator))
- systemd::unit\_file: remove hasrestart/hasstatus params [\#264](https://github.com/voxpupuli/puppet-systemd/pull/264) ([bastelfreak](https://github.com/bastelfreak))
- Remove restart\_service on service\_limits define [\#193](https://github.com/voxpupuli/puppet-systemd/pull/193) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Revisit setting daemon-reload to true by default [\#284](https://github.com/voxpupuli/puppet-systemd/issues/284)
- The module should have the ability to reload services that have outdated unit dropin files [\#282](https://github.com/voxpupuli/puppet-systemd/issues/282)
- Add restart\_service parameter on service\_limits for compatibility [\#313](https://github.com/voxpupuli/puppet-systemd/pull/313) ([ekohl](https://github.com/ekohl))
- add support for fedora 36 & 37 [\#309](https://github.com/voxpupuli/puppet-systemd/pull/309) ([jhoblitt](https://github.com/jhoblitt))
- Allow MemorySwapMax to be specified as service limit [\#304](https://github.com/voxpupuli/puppet-systemd/pull/304) ([traylenator](https://github.com/traylenator))
- add udevadm & udev facts [\#292](https://github.com/voxpupuli/puppet-systemd/pull/292) ([jhoblitt](https://github.com/jhoblitt))
- Make Systemd::Unit type stricter [\#290](https://github.com/voxpupuli/puppet-systemd/pull/290) ([traylenator](https://github.com/traylenator))
- New systemd::manage\_unit, systemd::manage\_dropin types [\#288](https://github.com/voxpupuli/puppet-systemd/pull/288) ([traylenator](https://github.com/traylenator))
- Add support for Ubuntu 22.04 [\#278](https://github.com/voxpupuli/puppet-systemd/pull/278) ([simondeziel](https://github.com/simondeziel))
- Notify services by default on drop in files [\#194](https://github.com/voxpupuli/puppet-systemd/pull/194) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- systemd-timesyncd package should be managed, if required [\#294](https://github.com/voxpupuli/puppet-systemd/issues/294)
- feat: manage timesyncd package on Debian \>= 11 and Ubuntu \>= 20.04 [\#296](https://github.com/voxpupuli/puppet-systemd/pull/296) ([saz](https://github.com/saz))
- resolved: `onlyif` snippet requires shell support [\#293](https://github.com/voxpupuli/puppet-systemd/pull/293) ([simondeziel](https://github.com/simondeziel))
- Correct docs for name var of systemd::dropin\_file [\#289](https://github.com/voxpupuli/puppet-systemd/pull/289) ([traylenator](https://github.com/traylenator))

## [v3.10.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.10.0) (2022-06-20)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.9.0...v3.10.0)

**Implemented enhancements:**

- systemd::timer: move variable definition close to where it is used [\#280](https://github.com/voxpupuli/puppet-systemd/pull/280) ([simondeziel](https://github.com/simondeziel))
- Add comment hint about initrd for folks [\#279](https://github.com/voxpupuli/puppet-systemd/pull/279) ([jcpunk](https://github.com/jcpunk))
- Fix systemctl daemon-reload after file additions [\#277](https://github.com/voxpupuli/puppet-systemd/pull/277) ([trevor-vaughan](https://github.com/trevor-vaughan))
- systemd::resolved: save readlink's value to avoid calling it twice [\#276](https://github.com/voxpupuli/puppet-systemd/pull/276) ([simondeziel](https://github.com/simondeziel))

**Fixed bugs:**

- systemd::dropin\_file doesn't cause a systemd daemon-reload [\#234](https://github.com/voxpupuli/puppet-systemd/issues/234)

**Merged pull requests:**

- Minor wordsmithing in README [\#283](https://github.com/voxpupuli/puppet-systemd/pull/283) ([op-ct](https://github.com/op-ct))
- Correct spelling mistakes [\#275](https://github.com/voxpupuli/puppet-systemd/pull/275) ([EdwardBetts](https://github.com/EdwardBetts))

## [v3.9.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.9.0) (2022-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.8.0...v3.9.0)

**Implemented enhancements:**

- Add machine-info information management [\#272](https://github.com/voxpupuli/puppet-systemd/pull/272) ([jcpunk](https://github.com/jcpunk))
- Add management of systemd-oomd [\#271](https://github.com/voxpupuli/puppet-systemd/pull/271) ([jcpunk](https://github.com/jcpunk))
- Add parameter to manage default target [\#270](https://github.com/voxpupuli/puppet-systemd/pull/270) ([jcpunk](https://github.com/jcpunk))
- Support Service Limits specified in Bytes [\#268](https://github.com/voxpupuli/puppet-systemd/pull/268) ([optiz0r](https://github.com/optiz0r))
- Allows % and infinity for Memory Limits + Add MemoryMin [\#267](https://github.com/voxpupuli/puppet-systemd/pull/267) ([SeanHood](https://github.com/SeanHood))
- Add CentOS 9 to supported operating systems [\#266](https://github.com/voxpupuli/puppet-systemd/pull/266) ([kajinamit](https://github.com/kajinamit))
- Add function systemd::systemd\_escape [\#243](https://github.com/voxpupuli/puppet-systemd/pull/243) ([jkroepke](https://github.com/jkroepke))

**Fixed bugs:**

- Ensure systemd-networkd is available prior to notifying service [\#269](https://github.com/voxpupuli/puppet-systemd/pull/269) ([mat1010](https://github.com/mat1010))

**Closed issues:**

- systemd target support [\#265](https://github.com/voxpupuli/puppet-systemd/issues/265)
- systemd::escape function is does not escape a lot of other characters [\#242](https://github.com/voxpupuli/puppet-systemd/issues/242)

## [v3.8.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.8.0) (2022-03-02)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.7.0...v3.8.0)

**Implemented enhancements:**

- dropin\_file: Implement service\_parameters hash [\#259](https://github.com/voxpupuli/puppet-systemd/pull/259) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- systemd::udev::rule: param rules now defaults to `[]` / fix broken tests [\#260](https://github.com/voxpupuli/puppet-systemd/pull/260) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- unit\_file: deprecate hasrestart/hasstatus params [\#261](https://github.com/voxpupuli/puppet-systemd/pull/261) ([bastelfreak](https://github.com/bastelfreak))

## [v3.7.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.7.0) (2022-02-23)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.6.0...v3.7.0)

**Implemented enhancements:**

- Install systemd-resolved on RedHat 7 [\#257](https://github.com/voxpupuli/puppet-systemd/pull/257) ([traylenator](https://github.com/traylenator))
- New parmater manage\_resolv\_conf for /etc/resolv.conf [\#256](https://github.com/voxpupuli/puppet-systemd/pull/256) ([traylenator](https://github.com/traylenator))
- Manage systemd-coredump config and setup [\#251](https://github.com/voxpupuli/puppet-systemd/pull/251) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- systemd-resolved cannot be fully disabled because /etc/resolv.conf is managed [\#203](https://github.com/voxpupuli/puppet-systemd/issues/203)
- Do not install  systemd-resolved RedHat 8 [\#254](https://github.com/voxpupuli/puppet-systemd/pull/254) ([traylenator](https://github.com/traylenator))
- timer: timer unit must depend on service unit. [\#253](https://github.com/voxpupuli/puppet-systemd/pull/253) ([olifre](https://github.com/olifre))
- Don't manage /etc/resolv.conf if systemd-resolved is stopped [\#252](https://github.com/voxpupuli/puppet-systemd/pull/252) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- missing hiera lookup\_options [\#196](https://github.com/voxpupuli/puppet-systemd/issues/196)

**Merged pull requests:**

- Addition of Trivial Acceptance Tests [\#255](https://github.com/voxpupuli/puppet-systemd/pull/255) ([traylenator](https://github.com/traylenator))
- document systemd::unit\_file example with puppet-strings [\#250](https://github.com/voxpupuli/puppet-systemd/pull/250) ([bastelfreak](https://github.com/bastelfreak))

## [v3.6.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.6.0) (2022-02-15)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.5.2...v3.6.0)

**Implemented enhancements:**

- unit\_file: Implement selinux\_ignore\_defaults [\#248](https://github.com/voxpupuli/puppet-systemd/pull/248) ([bastelfreak](https://github.com/bastelfreak))
- unit\_file: Implement hasrestart/hasstatus [\#247](https://github.com/voxpupuli/puppet-systemd/pull/247) ([bastelfreak](https://github.com/bastelfreak))
- Install systemd-resolved on CentOS 8 and 9 [\#246](https://github.com/voxpupuli/puppet-systemd/pull/246) ([traylenator](https://github.com/traylenator))
- Manage entries in modules-load.d directory [\#244](https://github.com/voxpupuli/puppet-systemd/pull/244) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- systemd::escape: Also escape - \(dash\) [\#245](https://github.com/voxpupuli/puppet-systemd/pull/245) ([weaselp](https://github.com/weaselp))

## [v3.5.2](https://github.com/voxpupuli/puppet-systemd/tree/v3.5.2) (2022-01-12)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.5.1...v3.5.2)

**Fixed bugs:**

- timesyncd compatibility with Debian 8 [\#239](https://github.com/voxpupuli/puppet-systemd/pull/239) ([tuxmea](https://github.com/tuxmea))
- Link the unit file to /dev/null when "enable =\> mask" [\#236](https://github.com/voxpupuli/puppet-systemd/pull/236) ([simondeziel](https://github.com/simondeziel))

**Closed issues:**

- README refers to non-existent dns\_stub\_resolver parameter [\#195](https://github.com/voxpupuli/puppet-systemd/issues/195)
- Parameter value 'mask' for 'enable' does not work [\#188](https://github.com/voxpupuli/puppet-systemd/issues/188)

## [v3.5.1](https://github.com/voxpupuli/puppet-systemd/tree/v3.5.1) (2021-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.5.0...v3.5.1)

**Fixed bugs:**

- Declare a default for $accounting [\#229](https://github.com/voxpupuli/puppet-systemd/pull/229) ([ekohl](https://github.com/ekohl))
- Do a daemon reload for static units [\#199](https://github.com/voxpupuli/puppet-systemd/pull/199) ([simondeziel](https://github.com/simondeziel))

**Closed issues:**

- provide sensible default for systemd::accounting [\#231](https://github.com/voxpupuli/puppet-systemd/issues/231)
- daemon reload problem with 3.0.0 [\#190](https://github.com/voxpupuli/puppet-systemd/issues/190)

**Merged pull requests:**

- Correct use\_stub\_resolver example in README [\#230](https://github.com/voxpupuli/puppet-systemd/pull/230) ([traylenator](https://github.com/traylenator))

## [v3.5.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.5.0) (2021-09-13)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.4.0...v3.5.0)

**Implemented enhancements:**

- Add Gentoo support [\#227](https://github.com/voxpupuli/puppet-systemd/pull/227) ([bastelfreak](https://github.com/bastelfreak))
- Add CentOS/RHEL 9 support [\#226](https://github.com/voxpupuli/puppet-systemd/pull/226) ([mbaldessari](https://github.com/mbaldessari))
- Use os.family for RedHat based Hiera data [\#225](https://github.com/voxpupuli/puppet-systemd/pull/225) ([treydock](https://github.com/treydock))
- Add additional hash parameters for defined types [\#223](https://github.com/voxpupuli/puppet-systemd/pull/223) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 11 support [\#222](https://github.com/voxpupuli/puppet-systemd/pull/222) ([bastelfreak](https://github.com/bastelfreak))
- Add systemd::escape function [\#220](https://github.com/voxpupuli/puppet-systemd/pull/220) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Migrate static data from hiera to init.pp [\#221](https://github.com/voxpupuli/puppet-systemd/pull/221) ([bastelfreak](https://github.com/bastelfreak))

## [v3.4.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.4.0) (2021-09-03)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.3.0...v3.4.0)

**Implemented enhancements:**

- CentOS 8: Enable more accounting options [\#218](https://github.com/voxpupuli/puppet-systemd/pull/218) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- puppet-lint: fix top\_scope\_facts warnings [\#217](https://github.com/voxpupuli/puppet-systemd/pull/217) ([bastelfreak](https://github.com/bastelfreak))
- add puppet-lint-param-docs [\#216](https://github.com/voxpupuli/puppet-systemd/pull/216) ([bastelfreak](https://github.com/bastelfreak))

## [v3.3.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.3.0) (2021-08-25)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.2.0...v3.3.0)

**Implemented enhancements:**

- Add support for strict mode for DNS over TLS [\#200](https://github.com/voxpupuli/puppet-systemd/pull/200) ([ghost](https://github.com/ghost))

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#213](https://github.com/voxpupuli/puppet-systemd/pull/213) ([smortex](https://github.com/smortex))

## [v3.2.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.2.0) (2021-07-27)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Add option to purge non-managed networkd files [\#209](https://github.com/voxpupuli/puppet-systemd/pull/209) ([bastelfreak](https://github.com/bastelfreak))
- Allow `systemd::unit_file` `Deferred` `content` [\#208](https://github.com/voxpupuli/puppet-systemd/pull/208) ([alexjfisher](https://github.com/alexjfisher))
- systemd::network: Validate if content/source are set for file resource [\#205](https://github.com/voxpupuli/puppet-systemd/pull/205) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Add puppet-strings documentation for systemd::network [\#207](https://github.com/voxpupuli/puppet-systemd/pull/207) ([bastelfreak](https://github.com/bastelfreak))
- Fix `Optional` datatype for non-optional parameters [\#206](https://github.com/voxpupuli/puppet-systemd/pull/206) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-systemd/tree/v3.1.0) (2021-07-12)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/3.0.0...v3.1.0)

**Implemented enhancements:**

- Accept Datatype Sensitive for $content [\#201](https://github.com/voxpupuli/puppet-systemd/pull/201) ([cocker-cc](https://github.com/cocker-cc))

**Merged pull requests:**

- Correct puppet-strings documentation [\#192](https://github.com/voxpupuli/puppet-systemd/pull/192) ([ekohl](https://github.com/ekohl))
- Add notify\_service support to dropin\_file [\#191](https://github.com/voxpupuli/puppet-systemd/pull/191) ([ekohl](https://github.com/ekohl))

## [3.0.0](https://github.com/voxpupuli/puppet-systemd/tree/3.0.0) (2021-04-16)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.12.0...3.0.0)

**Breaking changes:**

- Drop Puppet 4 and 5 support + daemon-reload code [\#171](https://github.com/voxpupuli/puppet-systemd/pull/171) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- add ubuntu2004 [\#187](https://github.com/voxpupuli/puppet-systemd/pull/187) ([GervaisdeM](https://github.com/GervaisdeM))
- allow Puppet 7 and add to Travis testing; remove Puppet 5 from Travis testing [\#183](https://github.com/voxpupuli/puppet-systemd/pull/183) ([kenyon](https://github.com/kenyon))
- metadata: allow stdlib 7.0.0 and inifile 5.0.0 [\#182](https://github.com/voxpupuli/puppet-systemd/pull/182) ([kenyon](https://github.com/kenyon))

**Closed issues:**

- Static units cannot be enabled [\#180](https://github.com/voxpupuli/puppet-systemd/issues/180)
- Cyclic dependency error when using systemd::unit\_file in multiple classes [\#178](https://github.com/voxpupuli/puppet-systemd/issues/178)

**Merged pull requests:**

- release 3.0.0 [\#189](https://github.com/voxpupuli/puppet-systemd/pull/189) ([bastelfreak](https://github.com/bastelfreak))
- Bump version to 3.0.0-rc0 [\#186](https://github.com/voxpupuli/puppet-systemd/pull/186) ([ekohl](https://github.com/ekohl))
- Correct path in use\_stub\_resolver documentation [\#177](https://github.com/voxpupuli/puppet-systemd/pull/177) ([ekohl](https://github.com/ekohl))

## [2.12.0](https://github.com/voxpupuli/puppet-systemd/tree/2.12.0) (2021-02-10)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.11.0...2.12.0)

**Implemented enhancements:**

- Allow service reloading \#159 [\#175](https://github.com/voxpupuli/puppet-systemd/pull/175) ([k0ka](https://github.com/k0ka))
- Allow additional option for $cache parameter [\#169](https://github.com/voxpupuli/puppet-systemd/pull/169) ([bryangwilliam](https://github.com/bryangwilliam))
- Add management of udev objects [\#165](https://github.com/voxpupuli/puppet-systemd/pull/165) ([jcpunk](https://github.com/jcpunk))

## [2.11.0](https://github.com/voxpupuli/puppet-systemd/tree/2.11.0) (2021-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.10.0...2.11.0)

**Implemented enhancements:**

- Move lint control statements out of documentation [\#172](https://github.com/voxpupuli/puppet-systemd/pull/172) ([ekohl](https://github.com/ekohl))
- Permit using arrays to make extending lists easier [\#164](https://github.com/voxpupuli/puppet-systemd/pull/164) ([jcpunk](https://github.com/jcpunk))
- Add parameter for ENCs to make loginctl\_users easily [\#163](https://github.com/voxpupuli/puppet-systemd/pull/163) ([jcpunk](https://github.com/jcpunk))
- Fix yamllint [\#161](https://github.com/voxpupuli/puppet-systemd/pull/161) ([jcpunk](https://github.com/jcpunk))
- Resolve puppet-lint warnings [\#160](https://github.com/voxpupuli/puppet-systemd/pull/160) ([jcpunk](https://github.com/jcpunk))
- Convert from mocha to rspec-mocks [\#158](https://github.com/voxpupuli/puppet-systemd/pull/158) ([ekohl](https://github.com/ekohl))
- Add ability to specify supported option 'infinity' for LimitNPROC [\#152](https://github.com/voxpupuli/puppet-systemd/pull/152) ([hdeheer](https://github.com/hdeheer))

**Closed issues:**

- Add support to use infinity with LimitNPROC [\#173](https://github.com/voxpupuli/puppet-systemd/issues/173)
- Need a new release [\#155](https://github.com/voxpupuli/puppet-systemd/issues/155)

**Merged pull requests:**

- Fix tests with rspec-puppet 2.8.0 [\#174](https://github.com/voxpupuli/puppet-systemd/pull/174) ([raphink](https://github.com/raphink))

## [2.10.0](https://github.com/voxpupuli/puppet-systemd/tree/2.10.0) (2020-08-21)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.9.0...2.10.0)

**Implemented enhancements:**

- Fix typo in parameter name in class documentation [\#156](https://github.com/voxpupuli/puppet-systemd/pull/156) ([ekohl](https://github.com/ekohl))
- Add selinux\_ignore\_defaults support to dropin\_file and service\_limits [\#151](https://github.com/voxpupuli/puppet-systemd/pull/151) ([tobias-urdin](https://github.com/tobias-urdin))
- pdk update [\#150](https://github.com/voxpupuli/puppet-systemd/pull/150) ([TheMeier](https://github.com/TheMeier))
- add factory for dropin files [\#149](https://github.com/voxpupuli/puppet-systemd/pull/149) ([TheMeier](https://github.com/TheMeier))

**Closed issues:**

- add timer support [\#118](https://github.com/voxpupuli/puppet-systemd/issues/118)
- Cache cannot be set to no in /etc/systemd/resolved.conf [\#113](https://github.com/voxpupuli/puppet-systemd/issues/113)
- Please release a new version with stdlib 6 support [\#105](https://github.com/voxpupuli/puppet-systemd/issues/105)
- Regex error when tying to set CPUQuota service limit. [\#91](https://github.com/voxpupuli/puppet-systemd/issues/91)
- Include puppetlabs-inifile in the dependencies list [\#77](https://github.com/voxpupuli/puppet-systemd/issues/77)
- migration path drop in file  from 0.4.0 to 1.0.0 [\#40](https://github.com/voxpupuli/puppet-systemd/issues/40)
- 'systemctl daemon-reload' is not qualified [\#22](https://github.com/voxpupuli/puppet-systemd/issues/22)

**Merged pull requests:**

- Use @api private instead of a NOTE [\#157](https://github.com/voxpupuli/puppet-systemd/pull/157) ([raphink](https://github.com/raphink))
- Allow CPUQuota greater than 100% [\#147](https://github.com/voxpupuli/puppet-systemd/pull/147) ([Hexta](https://github.com/Hexta))

## [2.9.0](https://github.com/voxpupuli/puppet-systemd/tree/2.9.0) (2020-03-11)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.8.0...2.9.0)

**Breaking changes:**

- Revert "add option for persistent logging \(\#127\)" [\#146](https://github.com/voxpupuli/puppet-systemd/pull/146) ([bastelfreak](https://github.com/bastelfreak))
- add option for persistent logging [\#127](https://github.com/voxpupuli/puppet-systemd/pull/127) ([djvl](https://github.com/djvl))

**Implemented enhancements:**

- Add EL8 Support [\#144](https://github.com/voxpupuli/puppet-systemd/pull/144) ([trevor-vaughan](https://github.com/trevor-vaughan))
- Add Fedora 30/31 compatibility [\#141](https://github.com/voxpupuli/puppet-systemd/pull/141) ([bastelfreak](https://github.com/bastelfreak))
- New systemd::timer define type [\#138](https://github.com/voxpupuli/puppet-systemd/pull/138) ([mmoll](https://github.com/mmoll))
- Add SLES 12/15 support [\#137](https://github.com/voxpupuli/puppet-systemd/pull/137) ([msurato](https://github.com/msurato))

**Closed issues:**

- Discussion: use class instead of exec for notification [\#2](https://github.com/voxpupuli/puppet-systemd/issues/2)

**Merged pull requests:**

- Release of 2.9.0 [\#145](https://github.com/voxpupuli/puppet-systemd/pull/145) ([trevor-vaughan](https://github.com/trevor-vaughan))
- fix Issue 113 [\#140](https://github.com/voxpupuli/puppet-systemd/pull/140) ([schlitzered](https://github.com/schlitzered))

## [2.8.0](https://github.com/voxpupuli/puppet-systemd/tree/2.8.0) (2020-01-08)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.7.0...2.8.0)

**Implemented enhancements:**

- Rubocop [\#135](https://github.com/voxpupuli/puppet-systemd/pull/135) ([raphink](https://github.com/raphink))
- Convert to PDK [\#132](https://github.com/voxpupuli/puppet-systemd/pull/132) ([raphink](https://github.com/raphink))
- Add loginctl\_user type/provider [\#131](https://github.com/voxpupuli/puppet-systemd/pull/131) ([raphink](https://github.com/raphink))
- Update types to avoid / in unit or drop file name [\#130](https://github.com/voxpupuli/puppet-systemd/pull/130) ([traylenator](https://github.com/traylenator))
- Force tmpfiles.d drop file to end in .conf [\#129](https://github.com/voxpupuli/puppet-systemd/pull/129) ([traylenator](https://github.com/traylenator))
- Add OOMScoreAdjust to Systemd::ServiceLimits type [\#128](https://github.com/voxpupuli/puppet-systemd/pull/128) ([jlutran](https://github.com/jlutran))
- allow puppetlabs/inifile 4.x [\#126](https://github.com/voxpupuli/puppet-systemd/pull/126) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Release 2.8.0 [\#134](https://github.com/voxpupuli/puppet-systemd/pull/134) ([raphink](https://github.com/raphink))
- Correct CPUQuota service limit regex [\#92](https://github.com/voxpupuli/puppet-systemd/pull/92) ([matt6697](https://github.com/matt6697))

## [2.7.0](https://github.com/voxpupuli/puppet-systemd/tree/2.7.0) (2019-10-29)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.6.0...2.7.0)

**Implemented enhancements:**

- add support for 'VirtuozzoLinux 7' [\#121](https://github.com/voxpupuli/puppet-systemd/pull/121) ([kBite](https://github.com/kBite))
- Manage logind service and configuration [\#120](https://github.com/voxpupuli/puppet-systemd/pull/120) ([fraenki](https://github.com/fraenki))
- allow Sensitive type for content param [\#115](https://github.com/voxpupuli/puppet-systemd/pull/115) ([TheMeier](https://github.com/TheMeier))

**Closed issues:**

- vacuum as routine task [\#123](https://github.com/voxpupuli/puppet-systemd/issues/123)
- Manage dropin\_file for target type systemd unit  [\#117](https://github.com/voxpupuli/puppet-systemd/issues/117)
- Allow Sensitive type for systemd::dropin\_file::content [\#114](https://github.com/voxpupuli/puppet-systemd/issues/114)

**Merged pull requests:**

- Correct order when ensuring unit files are absent [\#122](https://github.com/voxpupuli/puppet-systemd/pull/122) ([ekohl](https://github.com/ekohl))

## [2.6.0](https://github.com/voxpupuli/puppet-systemd/tree/2.6.0) (2019-06-17)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.5.1...2.6.0)

**Implemented enhancements:**

- Allow for lazy/eager systemctl daemon reloading [\#111](https://github.com/voxpupuli/puppet-systemd/pull/111) ([JohnLyman](https://github.com/JohnLyman))
- Remove stray `v` from Changelog `config.future_release` [\#110](https://github.com/voxpupuli/puppet-systemd/pull/110) ([alexjfisher](https://github.com/alexjfisher))

## [2.5.1](https://github.com/voxpupuli/puppet-systemd/tree/2.5.1) (2019-05-29)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.5.0...2.5.1)

**Implemented enhancements:**

- Pin `public_suffix` to `3.0.3` on rvm 2.1.9 builds [\#108](https://github.com/voxpupuli/puppet-systemd/pull/108) ([alexjfisher](https://github.com/alexjfisher))
- run CI jobs on xenial instead of trusty [\#107](https://github.com/voxpupuli/puppet-systemd/pull/107) ([bastelfreak](https://github.com/bastelfreak))

## [2.5.0](https://github.com/voxpupuli/puppet-systemd/tree/2.5.0) (2019-05-29)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.4.0...2.5.0)

**Implemented enhancements:**

- Allow `puppetlabs/stdlib` 6.x [\#103](https://github.com/voxpupuli/puppet-systemd/pull/103) ([alexjfisher](https://github.com/alexjfisher))

## [2.4.0](https://github.com/voxpupuli/puppet-systemd/tree/2.4.0) (2019-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.3.0...2.4.0)

**Implemented enhancements:**

- Allow `puppetlabs/inifile` 3.x [\#101](https://github.com/voxpupuli/puppet-systemd/pull/101) ([alexjfisher](https://github.com/alexjfisher))

## [2.3.0](https://github.com/voxpupuli/puppet-systemd/tree/2.3.0) (2019-04-10)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.2.0...2.3.0)

**Implemented enhancements:**

- Add parameter to enable/disable the management of journald [\#99](https://github.com/voxpupuli/puppet-systemd/pull/99) ([dhoppe](https://github.com/dhoppe))

**Closed issues:**

- Puppet version compatibility [\#34](https://github.com/voxpupuli/puppet-systemd/issues/34)

## [2.2.0](https://github.com/voxpupuli/puppet-systemd/tree/2.2.0) (2019-02-25)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.1.0...2.2.0)

**Implemented enhancements:**

- Puppet 6 support [\#96](https://github.com/voxpupuli/puppet-systemd/pull/96) ([ekohl](https://github.com/ekohl))
- Allow specifying owner/group/mode/show\_diff [\#94](https://github.com/voxpupuli/puppet-systemd/pull/94) ([simondeziel](https://github.com/simondeziel))
- Manage journald service and configuration [\#89](https://github.com/voxpupuli/puppet-systemd/pull/89) ([treydock](https://github.com/treydock))
- Add support for DNSoverTLS [\#88](https://github.com/voxpupuli/puppet-systemd/pull/88) ([shibumi](https://github.com/shibumi))
- unit.d directory should be purged of unmanaged dropin files [\#41](https://github.com/voxpupuli/puppet-systemd/pull/41) ([treydock](https://github.com/treydock))
- Add Journald support [\#14](https://github.com/voxpupuli/puppet-systemd/pull/14) ([duritong](https://github.com/duritong))

**Closed issues:**

- Hiera usage for systemd::unit\_file [\#86](https://github.com/voxpupuli/puppet-systemd/issues/86)
- Please push a new module to the forge that includes service\_limits [\#25](https://github.com/voxpupuli/puppet-systemd/issues/25)

## [2.1.0](https://github.com/voxpupuli/puppet-systemd/tree/2.1.0) (2018-08-31)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/2.0.0...2.1.0)

**Implemented enhancements:**

- do not access facts as top scope variable [\#85](https://github.com/voxpupuli/puppet-systemd/pull/85) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x [\#83](https://github.com/voxpupuli/puppet-systemd/pull/83) ([bastelfreak](https://github.com/bastelfreak))
- Modify service limit type [\#81](https://github.com/voxpupuli/puppet-systemd/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- Add parameter to select resolver [\#79](https://github.com/voxpupuli/puppet-systemd/pull/79) ([amateo](https://github.com/amateo))
- Fix CHANGELOG.md duplicate footer [\#78](https://github.com/voxpupuli/puppet-systemd/pull/78) ([alexjfisher](https://github.com/alexjfisher))

**Merged pull requests:**

- Handle ensuring service\_limits to be absent [\#80](https://github.com/voxpupuli/puppet-systemd/pull/80) ([ekohl](https://github.com/ekohl))

## [2.0.0](https://github.com/voxpupuli/puppet-systemd/tree/2.0.0) (2018-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/1.1.1...2.0.0)

**Breaking changes:**

- move params to data-in-modules [\#67](https://github.com/voxpupuli/puppet-systemd/pull/67) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- add ubuntu 18.04 support [\#72](https://github.com/voxpupuli/puppet-systemd/pull/72) ([bastelfreak](https://github.com/bastelfreak))
- bump facter to latest 2.x version [\#71](https://github.com/voxpupuli/puppet-systemd/pull/71) ([bastelfreak](https://github.com/bastelfreak))
- Add enable and active parameters to unit\_file [\#69](https://github.com/voxpupuli/puppet-systemd/pull/69) ([jcharaoui](https://github.com/jcharaoui))
- Update the documentation of facts [\#68](https://github.com/voxpupuli/puppet-systemd/pull/68) ([ekohl](https://github.com/ekohl))
- purge legacy puppet-lint checks [\#66](https://github.com/voxpupuli/puppet-systemd/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- Add support for Resource Accounting via systemd [\#65](https://github.com/voxpupuli/puppet-systemd/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- Reuse the systemd::dropin\_file in service\_limits [\#61](https://github.com/voxpupuli/puppet-systemd/pull/61) ([ekohl](https://github.com/ekohl))
- Allow resolved class to configure DNS settings [\#59](https://github.com/voxpupuli/puppet-systemd/pull/59) ([hfm](https://github.com/hfm))
- Replace iterator with stdlib function [\#58](https://github.com/voxpupuli/puppet-systemd/pull/58) ([jfleury-at-ovh](https://github.com/jfleury-at-ovh))
- implement github changelog generator [\#45](https://github.com/voxpupuli/puppet-systemd/pull/45) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Better test for systemd \(and other init systems\) [\#37](https://github.com/voxpupuli/puppet-systemd/issues/37)

**Merged pull requests:**

- fix puppet-linter warnings in README.md [\#75](https://github.com/voxpupuli/puppet-systemd/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- cleanup README.md [\#60](https://github.com/voxpupuli/puppet-systemd/pull/60) ([bastelfreak](https://github.com/bastelfreak))

## [1.1.1](https://github.com/voxpupuli/puppet-systemd/tree/1.1.1) (2017-11-29)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/1.1.0...1.1.1)

**Implemented enhancements:**

- Clean up test tooling [\#54](https://github.com/voxpupuli/puppet-systemd/pull/54) ([ekohl](https://github.com/ekohl))
- Correct parameter documentation [\#53](https://github.com/voxpupuli/puppet-systemd/pull/53) ([ekohl](https://github.com/ekohl))
- Use a space-separated in timesyncd.conf [\#50](https://github.com/voxpupuli/puppet-systemd/pull/50) ([hfm](https://github.com/hfm))
- Use the same systemd drop-in file for different units [\#46](https://github.com/voxpupuli/puppet-systemd/pull/46) ([countsudoku](https://github.com/countsudoku))

**Closed issues:**

- Not able to set limits via systemd class [\#49](https://github.com/voxpupuli/puppet-systemd/issues/49)
- fact systemd\_internal\_services is empty [\#47](https://github.com/voxpupuli/puppet-systemd/issues/47)

**Merged pull requests:**

- Use the correct type on $service\_limits [\#52](https://github.com/voxpupuli/puppet-systemd/pull/52) ([ekohl](https://github.com/ekohl))
- Fix issue \#47 [\#48](https://github.com/voxpupuli/puppet-systemd/pull/48) ([axxelG](https://github.com/axxelG))

## [1.1.0](https://github.com/voxpupuli/puppet-systemd/tree/1.1.0) (2017-10-24)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Add systemd-timesyncd support [\#43](https://github.com/voxpupuli/puppet-systemd/pull/43) ([bastelfreak](https://github.com/bastelfreak))
- Reuse the service\_provider fact from stdlib [\#42](https://github.com/voxpupuli/puppet-systemd/pull/42) ([ekohl](https://github.com/ekohl))
- \(doc\) Adds examples of running the service created [\#29](https://github.com/voxpupuli/puppet-systemd/pull/29) ([petems](https://github.com/petems))
- Quote hash keys in example of service limits [\#20](https://github.com/voxpupuli/puppet-systemd/pull/20) ([stbenjam](https://github.com/stbenjam))

**Closed issues:**

- Add explicit ordering to README.md [\#24](https://github.com/voxpupuli/puppet-systemd/issues/24)
- Manage drop-in files [\#15](https://github.com/voxpupuli/puppet-systemd/issues/15)

## [1.0.0](https://github.com/voxpupuli/puppet-systemd/tree/1.0.0) (2017-09-04)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/0.4.0...1.0.0)

**Implemented enhancements:**

- Add support for drop-in files [\#39](https://github.com/voxpupuli/puppet-systemd/pull/39) ([countsudoku](https://github.com/countsudoku))
- Adds control group limits to ServiceLimits [\#36](https://github.com/voxpupuli/puppet-systemd/pull/36) ([trevor-vaughan](https://github.com/trevor-vaughan))
- General cleanup + add Puppet4 datatypes [\#32](https://github.com/voxpupuli/puppet-systemd/pull/32) ([bastelfreak](https://github.com/bastelfreak))
- add management for systemd-resolved [\#31](https://github.com/voxpupuli/puppet-systemd/pull/31) ([bastelfreak](https://github.com/bastelfreak))
- Add a network defined resource [\#30](https://github.com/voxpupuli/puppet-systemd/pull/30) ([bastelfreak](https://github.com/bastelfreak))
- Add seltype to systemd directory [\#27](https://github.com/voxpupuli/puppet-systemd/pull/27) ([petems](https://github.com/petems))
- Add MemoryLimit to limits template [\#23](https://github.com/voxpupuli/puppet-systemd/pull/23) ([pkilambi](https://github.com/pkilambi))
- Update to support Puppet 4 [\#18](https://github.com/voxpupuli/puppet-systemd/pull/18) ([trevor-vaughan](https://github.com/trevor-vaughan))
- Manage resource limits of services [\#13](https://github.com/voxpupuli/puppet-systemd/pull/13) ([ruriky](https://github.com/ruriky))
- Refactor systemd facts [\#12](https://github.com/voxpupuli/puppet-systemd/pull/12) ([petems](https://github.com/petems))

**Closed issues:**

- PR\#18 broke service limits capacity [\#35](https://github.com/voxpupuli/puppet-systemd/issues/35)
- stdlib functions are used, but no stdlib requirement in metadata.json [\#28](https://github.com/voxpupuli/puppet-systemd/issues/28)
- investigate update to camptocamp/systemd module  [\#21](https://github.com/voxpupuli/puppet-systemd/issues/21)
- Module should be updated to use the new Puppet 4 goodness [\#17](https://github.com/voxpupuli/puppet-systemd/issues/17)

**Merged pull requests:**

- it's systemd not SystemD [\#33](https://github.com/voxpupuli/puppet-systemd/pull/33) ([shibumi](https://github.com/shibumi))

## [0.4.0](https://github.com/voxpupuli/puppet-systemd/tree/0.4.0) (2016-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-systemd/compare/0.3.0...0.4.0)

**Implemented enhancements:**

- Add target param for the unit file [\#10](https://github.com/voxpupuli/puppet-systemd/pull/10) ([tampakrap](https://github.com/tampakrap))
- only use awk, instead of grep and awk [\#9](https://github.com/voxpupuli/puppet-systemd/pull/9) ([igalic](https://github.com/igalic))

**Closed issues:**

- No LICENSE file [\#11](https://github.com/voxpupuli/puppet-systemd/issues/11)
- Forge update  [\#7](https://github.com/voxpupuli/puppet-systemd/issues/7)

## [0.3.0](https://forge.puppetlabs.com/camptocamp/systemd/0.3.0) (2016-05-16)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.2.2...0.3.0)

**Implemented enhancements:**

- Shortcut for creating unit files / tmpfiles [\#4](https://github.com/camptocamp/puppet-systemd/pull/4) ([felixb](https://github.com/felixb))
- Add systemd facts [\#6](https://github.com/camptocamp/puppet-systemd/pull/6) ([roidelapluie](https://github.com/roidelapluie))


## [0.2.2](https://forge.puppetlabs.com/camptocamp/systemd/0.2.2) (2015-08-25)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.2.1...0.2.2)

**Implemented enhancements:**

- Add 'systemd-tmpfiles-create' [\#1](https://github.com/camptocamp/puppet-systemd/pull/1) ([roidelapluie](https://github.com/roidelapluie))


## [0.2.1](https://forge.puppetlabs.com/camptocamp/systemd/0.2.1) (2015-08-21)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.2.0...0.2.1)

- Use docker for acceptance tests

## [0.1.15](https://forge.puppetlabs.com/camptocamp/systemd/0.1.15) (2015-06-26)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.14...0.1.15)

- Fix strict_variables activation with rspec-puppet 2.2

## [0.1.14](https://forge.puppetlabs.com/camptocamp/systemd/0.1.14) (2015-05-28)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.13...0.1.14)

- Add beaker_spec_helper to Gemfile

## [0.1.13](https://forge.puppetlabs.com/camptocamp/systemd/0.1.13) (2015-05-26)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.12...0.1.13)

- Use random application order in nodeset

## [0.1.12](https://forge.puppetlabs.com/camptocamp/systemd/0.1.12) (2015-05-26)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.11...0.1.12)

- Add utopic & vivid nodesets

## [0.1.11](https://forge.puppetlabs.com/camptocamp/systemd/0.1.11) (2015-05-25)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.10...0.1.11)

- Don't allow failure on Puppet 4

## [0.1.10](https://forge.puppetlabs.com/camptocamp/systemd/0.1.10) (2015-05-13)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.9...0.1.10)

- Add puppet-lint-file_source_rights-check gem

## [0.1.9](https://forge.puppetlabs.com/camptocamp/systemd/0.1.9) (2015-05-12)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.8...0.1.9)

- Don't pin beaker

## [0.1.8](https://forge.puppetlabs.com/camptocamp/systemd/0.1.8) (2015-04-27)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.7...0.1.8)

- Add nodeset ubuntu-12.04-x86_64-openstack

## [0.1.7](https://forge.puppetlabs.com/camptocamp/systemd/0.1.7) (2015-04-03)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.1.6...0.1.7)

- Confine rspec pinning to ruby 1.8


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
