# Voxpupuli Acceptance Gem

[![Build Status](https://img.shields.io/travis/voxpupuli/voxpupuli-acceptance/master.svg?style=flat-square)](https://travis-ci.org/voxpupuli/voxpupuli-acceptance)
[![License](https://img.shields.io/github/license/voxpupuli/voxpupuli-acceptance.svg)](https://github.com/voxpupuli/voxpupuli-acceptance/blob/master/LICENSE)
[![Gem Version](https://img.shields.io/gem/v/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)
[![Gem Downloads](https://img.shields.io/gem/dt/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)

This is a helper Gem to acceptance test the various Vox Pupuli Puppet modules. This Gem provides common functionality for all beaker based acceptance testing. The aim is to reduce the boiler plate and need for modulesync.

# Usage
Add the `voxpupuli-acceptance` Gem to your `Gemfile`:

```ruby
gem 'voxpupuli-acceptance'
```

In your `spec/spec_helper_acceptance.rb`

```ruby
require 'voxpupuli/acceptance/spec_helper'

configure_beaker
```

# Running tests

This module provides no rake helpers but leaves that to [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Commonly invoked as:

```bash
BEAKER_setfile=centos7-64 bundle exec rake beaker
```

Other common environment variables:

* `BEAKER_HYPERVISOR` defaults to `docker`, can be set to `vagrant_libvirt`
* `BEAKER_destroy` can be set to `no` to avoid destroying the box after completion. Useful to inspect failures
* `BEAKER_provision` can be set to `no` to reuse a box. Note that the box must exist already. See `BEAKER_destroy`

Since it's still plain [RSpec](https://rspec.info/), it is also possible to call an individual test file:

```bash
BEAKER_setfile=centos7-64 bundle exec rspec spec/acceptance/my_test.rb
```

# Customizing host configuration

## Per host configuration

It is also possible to do per host configuration by providing a block:

```ruby
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'os.name') == 'CentOS'
    install_package(host, 'epel-release')
  end
end
```

## Installing Puppet Modules

### Metadata

By default the module uses [beaker-module_install_helper](https://github.com/puppetlabs/beaker-module_install_helper). Its approach is copying the module and then install every dependency as listed in the module's metadata.json. This is a slow process and if the latest modules aren't accepted, it can lead to problems.

```ruby
# This is the default
configure_beaker(modules: :metadata)
```

### Fixtures

An alternative is to use the fixtures:

```ruby
configure_beaker(modules: :fixtures)
```

This will switch to use [puppet-modulebuilder](https://github.com/puppetlabs/puppet-modulebuilder) on all modules present in `spec/fixtures/modules`. This is faster, but more importantly it also allows using git versions of modules. No dependency resolution is done and it is up to the module developer to ensure it's a correct set. It is also up to the module developer to ensure the fixtures are checked out before beaker runs.

```ruby
# In Rakefile
task :beaker => "spec_prep"
```

### None

It's also possible to skip module installation altogether, giving the module developer complete freedom to handle this.
```ruby
configure_beaker(modules: nil)
```
