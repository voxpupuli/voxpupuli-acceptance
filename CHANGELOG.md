# Changelog

All notable changes to this project will be documented in this file.

## [2.4.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/2.4.0) (2023-11-06)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/2.3.0...2.4.0)

**Implemented enhancements:**

- Avoid using legacy facts with beaker-hiera [\#74](https://github.com/voxpupuli/voxpupuli-acceptance/pull/74) ([ekohl](https://github.com/ekohl))
- Only read the local\_setup file once [\#30](https://github.com/voxpupuli/voxpupuli-acceptance/pull/30) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Document known issue with BEAKER\_PROVISION & beaker-docker [\#76](https://github.com/voxpupuli/voxpupuli-acceptance/pull/76) ([ekohl](https://github.com/ekohl))

## [2.3.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/2.3.0) (2023-10-24)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/2.2.0...2.3.0)

**Implemented enhancements:**

- Support the preinstalled BEAKER\_PUPPET\_COLLECTION [\#72](https://github.com/voxpupuli/voxpupuli-acceptance/pull/72) ([ekohl](https://github.com/ekohl))
- Add env var for puppet package name [\#71](https://github.com/voxpupuli/voxpupuli-acceptance/pull/71) ([bastelfreak](https://github.com/bastelfreak))

## [2.2.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/2.2.0) (2023-10-18)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/2.1.0...2.2.0)

**Implemented enhancements:**

- Pass AIO preference to package name selection [\#70](https://github.com/voxpupuli/voxpupuli-acceptance/pull/70) ([ekohl](https://github.com/ekohl))
- Switch from mixed case to uppercase env vars [\#59](https://github.com/voxpupuli/voxpupuli-acceptance/pull/59) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- rake.rb: fix typo in comment [\#67](https://github.com/voxpupuli/voxpupuli-acceptance/pull/67) ([kenyon](https://github.com/kenyon))
- fixtures.rb: fix typo in comment [\#66](https://github.com/voxpupuli/voxpupuli-acceptance/pull/66) ([kenyon](https://github.com/kenyon))
- README.md: fix link to rspec shared examples docs [\#65](https://github.com/voxpupuli/voxpupuli-acceptance/pull/65) ([kenyon](https://github.com/kenyon))

## [2.1.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/2.1.0) (2023-07-04)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/2.0.0...2.1.0)

**Implemented enhancements:**

- Configure Puppet repo unless BEAKER\_PUPPET\_COLLECTION=none [\#62](https://github.com/voxpupuli/voxpupuli-acceptance/pull/62) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- README.md: adjust badges to Vox Pupuli defaults [\#61](https://github.com/voxpupuli/voxpupuli-acceptance/pull/61) ([bastelfreak](https://github.com/bastelfreak))
- CI: Run on PRs+merges to master [\#60](https://github.com/voxpupuli/voxpupuli-acceptance/pull/60) ([bastelfreak](https://github.com/bastelfreak))
- README.md: Switch beaker env vars to uppercase [\#58](https://github.com/voxpupuli/voxpupuli-acceptance/pull/58) ([bastelfreak](https://github.com/bastelfreak))

## [2.0.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/2.0.0) (2023-05-10)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/1.2.1...2.0.0)

**Breaking changes:**

- Drop puppet install helper [\#54](https://github.com/voxpupuli/voxpupuli-acceptance/pull/54) ([bastelfreak](https://github.com/bastelfreak))
- Drop Ruby 2.4/2.5/2.6 support [\#53](https://github.com/voxpupuli/voxpupuli-acceptance/pull/53) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Ruby 3.2 support [\#55](https://github.com/voxpupuli/voxpupuli-acceptance/pull/55) ([bastelfreak](https://github.com/bastelfreak))
- BEAKER\_PUPPET\_COLLECTION: Default to puppet 7 [\#50](https://github.com/voxpupuli/voxpupuli-acceptance/pull/50) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- CI: Build gems with strictness and verbosity & gemspec: Add version constraints for dependencies [\#52](https://github.com/voxpupuli/voxpupuli-acceptance/pull/52) ([bastelfreak](https://github.com/bastelfreak))
- GCG: Add faraday-retry dep [\#51](https://github.com/voxpupuli/voxpupuli-acceptance/pull/51) ([bastelfreak](https://github.com/bastelfreak))
- Rename example modules to be valid on the forge [\#48](https://github.com/voxpupuli/voxpupuli-acceptance/pull/48) ([ekohl](https://github.com/ekohl))

## [1.2.1](https://github.com/voxpupuli/voxpupuli-acceptance/tree/1.2.1) (2023-03-28)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/1.2.0...1.2.1)

**Fixed bugs:**

- Restrict to Beaker 4 [\#46](https://github.com/voxpupuli/voxpupuli-acceptance/pull/46) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- dependabot: check for github actions and gems [\#44](https://github.com/voxpupuli/voxpupuli-acceptance/pull/44) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs\_spec\_helper: require 4.x and newer [\#41](https://github.com/voxpupuli/voxpupuli-acceptance/pull/41) ([bastelfreak](https://github.com/bastelfreak))

## [1.2.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/1.2.0) (2022-08-24)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/1.1.0...1.2.0)

**Implemented enhancements:**

- Add a GitHub Action formatter to rspec [\#38](https://github.com/voxpupuli/voxpupuli-acceptance/pull/38) ([ekohl](https://github.com/ekohl))

## [1.1.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/1.1.0) (2022-01-21)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/1.0.1...1.1.0)

**Implemented enhancements:**

- cleanup dependencies; depend on beaker \>= 4.33.0 [\#35](https://github.com/voxpupuli/voxpupuli-acceptance/pull/35) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Add puppetlabs\_spec\_helper 4 compatibility [\#34](https://github.com/voxpupuli/voxpupuli-acceptance/pull/34) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- cleanup release CI job; publish to github packages [\#36](https://github.com/voxpupuli/voxpupuli-acceptance/pull/36) ([bastelfreak](https://github.com/bastelfreak))
- Document vagrant beaker backend [\#33](https://github.com/voxpupuli/voxpupuli-acceptance/pull/33) ([bastelfreak](https://github.com/bastelfreak))
- Add Ruby 3.1 to CI matrix [\#32](https://github.com/voxpupuli/voxpupuli-acceptance/pull/32) ([bastelfreak](https://github.com/bastelfreak))

## [1.0.1](https://github.com/voxpupuli/voxpupuli-acceptance/tree/1.0.1) (2021-07-03)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/1.0.0...1.0.1)

**Fixed bugs:**

- Fix applying spec/setup\_acceptance\_node.erb [\#27](https://github.com/voxpupuli/voxpupuli-acceptance/pull/27) ([smortex](https://github.com/smortex))

## [1.0.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/1.0.0) (2021-05-21)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0.3.0...1.0.0)

**Implemented enhancements:**

- Change fact handling into a setting [\#25](https://github.com/voxpupuli/voxpupuli-acceptance/pull/25) ([ekohl](https://github.com/ekohl))
- Add a rake task [\#22](https://github.com/voxpupuli/voxpupuli-acceptance/pull/22) ([ekohl](https://github.com/ekohl))
- Support a Puppet-based acceptance node setup script [\#21](https://github.com/voxpupuli/voxpupuli-acceptance/pull/21) ([ekohl](https://github.com/ekohl))
- Add shared examples [\#20](https://github.com/voxpupuli/voxpupuli-acceptance/pull/20) ([ekohl](https://github.com/ekohl))
- Add integration with beaker-hiera [\#19](https://github.com/voxpupuli/voxpupuli-acceptance/pull/19) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Correct namespace of Fixtures + add an example [\#24](https://github.com/voxpupuli/voxpupuli-acceptance/pull/24) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Add a test suite [\#23](https://github.com/voxpupuli/voxpupuli-acceptance/pull/23) ([ekohl](https://github.com/ekohl))
- Use released github\_changelog\_generator [\#18](https://github.com/voxpupuli/voxpupuli-acceptance/pull/18) ([ekohl](https://github.com/ekohl))
- Expand the documentation with hypervisors and links [\#17](https://github.com/voxpupuli/voxpupuli-acceptance/pull/17) ([ekohl](https://github.com/ekohl))
- Convert to Github Actions [\#15](https://github.com/voxpupuli/voxpupuli-acceptance/pull/15) ([ekohl](https://github.com/ekohl))

## [0.3.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/0.3.0) (2020-10-09)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0.2.1...0.3.0)

**Implemented enhancements:**

- Add support to store environment variables as facts [\#13](https://github.com/voxpupuli/voxpupuli-acceptance/pull/13) ([ekohl](https://github.com/ekohl))

## [0.2.1](https://github.com/voxpupuli/voxpupuli-acceptance/tree/0.2.1) (2020-05-20)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0.2.0...0.2.1)

**Merged pull requests:**

- Avoid broken beaker versions 4.22.0 and 4.23.0 [\#11](https://github.com/voxpupuli/voxpupuli-acceptance/pull/11) ([dhoppe](https://github.com/dhoppe))
- Fix typo in README.md / Add Badges to README.md [\#10](https://github.com/voxpupuli/voxpupuli-acceptance/pull/10) ([bastelfreak](https://github.com/bastelfreak))

## [0.2.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/0.2.0) (2020-04-29)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0.1.1...0.2.0)

**Implemented enhancements:**

- Add fixtures module helper [\#8](https://github.com/voxpupuli/voxpupuli-acceptance/pull/8) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Fix typo in README.md [\#6](https://github.com/voxpupuli/voxpupuli-acceptance/pull/6) ([wbclark](https://github.com/wbclark))

## [0.1.1](https://github.com/voxpupuli/voxpupuli-acceptance/tree/0.1.1) (2020-04-06)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0.1.0...0.1.1)

**Merged pull requests:**

- Add a default rake task [\#4](https://github.com/voxpupuli/voxpupuli-acceptance/pull/4) ([ekohl](https://github.com/ekohl))

## [0.1.0](https://github.com/voxpupuli/voxpupuli-acceptance/tree/0.1.0) (2020-04-06)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-acceptance/compare/0ac3f59d43beced663c9dbf6ff9999f9549358d0...0.1.0)

**Merged pull requests:**

- add travis secret [\#2](https://github.com/voxpupuli/voxpupuli-acceptance/pull/2) ([bastelfreak](https://github.com/bastelfreak))
- Initial version [\#1](https://github.com/voxpupuli/voxpupuli-acceptance/pull/1) ([ekohl](https://github.com/ekohl))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
