# Change Log

## [1.0.0](https://forge.puppetlabs.com/camptocamp/systemd/1.0.0) (2017-09-04)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.4.0...1.0.0)

- Refactor systemd facts [\#12](https://github.com/camptocamp/puppet-systemd/pull/12) ([petems](https://github.com/petems))
- Manage resource limits of services [\#13](https://github.com/camptocamp/puppet-systemd/pull/13) ([ruriky](https://github.com/ruriky))
- Remove Puppet 3 tests
- Add MemoryLimit to limits template [\#23](https://github.com/camptocamp/puppet-systemd/pull/23) ([pkilambi](https://github.com/pkilambi))
- Linting
- Add seltype to systemd directory [\#27](https://github.com/camptocamp/puppet-systemd/pull/27) ([petems](https://github.com/petems))
- Add management for systemd-resolved [\#31](https://github.com/camptocamp/puppet-systemd/pull/31) ([bastelfreak](https://github.com/bastelfreak))
- Add a network defined resource [\#30](https://github.com/camptocamp/puppet-systemd/pull/30) ([bastelfreak](https://github.com/bastelfreak))
- Support for Puppet 4 [\#18](https://github.com/camptocamp/puppet-systemd/pull/18) ([trevor-vaughan](https://github.com/trevor-vaughan))
- Add Puppet4 datatypes [\#32](https://github.com/camptocamp/puppet-systemd/pull/32) ([bastelfreak](https://github.com/bastelfreak))
- Add control group limits to ServiceLimits [\#36](https://github.com/camptocamp/puppet-systemd/pull/36) ([trevor-vaughan](https://github.com/trevor-vaughan))
- Add support for drop-in files [\#39](https://github.com/camptocamp/puppet-systemd/pull/39) ([countsudoku](https://github.com/countsudoku))

## [0.4.0](https://forge.puppetlabs.com/camptocamp/systemd/0.4.0) (2016-08-18)
[Full Changelog](https://github.com/camptocamp/puppet-systemd/compare/0.3.0...0.4.0)

- Deprecate Ruby 1.8 tests
- Only use awk instead of grep and awk [\#9](https://github.com/camptocamp/puppet-systemd/pull/9) ([igalic](https://github.com/igalic))
- Add LICENSE (fix #11)
- Add target param for the unit file [\#10](https://github.com/camptocamp/puppet-systemd/pull/10) ([tampakrap](https://github.com/tampakrap))

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


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
