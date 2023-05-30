# Voxpupuli Acceptance Gem

[![Build Status](https://img.shields.io/travis/voxpupuli/voxpupuli-acceptance/master.svg?style=flat-square)](https://travis-ci.org/voxpupuli/voxpupuli-acceptance)
[![License](https://img.shields.io/github/license/voxpupuli/voxpupuli-acceptance.svg)](https://github.com/voxpupuli/voxpupuli-acceptance/blob/master/LICENSE)
[![Gem Version](https://img.shields.io/gem/v/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)
[![Gem Downloads](https://img.shields.io/gem/dt/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)

This is a helper Gem to acceptance test the various Vox Pupuli Puppet modules using [beaker](https://github.com/voxpupuli/beaker). This Gem provides common functionality for all beaker based acceptance testing. The aim is to reduce the boiler plate and need for modulesync.

# Usage
Add the `voxpupuli-acceptance` Gem to your `Gemfile`:

```ruby
gem 'voxpupuli-acceptance'
```

In your `spec/spec_helper_acceptance.rb`

```ruby
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker
```

# Running tests

This module provides rake helpers. It prefers [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper) but falls back to [beaker-rspec](https://github.com/voxpupuli/beaker-rspec). Commonly invoked as:

To do so, in your `Rakefile`

```ruby
require 'voxpupuli/acceptance/rake'
```

It can then be invoked as:

```bash
BEAKER_setfile=centos7-64 bundle exec rake beaker
```

Other common environment variables:

* `BEAKER_HYPERVISOR` defaults to `docker`, can be set to `vagrant_libvirt` or `vagrant` (using [VirtualBox](https://www.virtualbox.org/))
* `BEAKER_DESTROY` can be set to `no` to avoid destroying the box after completion. Useful to inspect failures. Another common value is `onpass` which deletes it only when the tests pass.
* `BEAKER_PROVISION` can be set to `no` to reuse a box. Note that the box must exist already. See `BEAKER_DESTROY`
* `BEAKER_SETFILE` is used to point to a setfile containing definitions. To avoid storing large YAML files in all repositories, [beaker-hostgenerator](https://github.com/voxpupuli/beaker-hostgenerator) is used to generate them on the fly when the file is not present.

Since it's still plain [RSpec](https://rspec.info/), it is also possible to call an individual test file:

```bash
BEAKER_SETFILE=centos7-64 bundle exec rspec spec/acceptance/my_test.rb
```

## Hypervisors

By default the Docker hypervisor is used. This can be changed with `BEAKER_HYPERVISOR`.

### Docker

The easiest way to debug in a [Docker](https://www.docker.com/) container is to open a shell:

```sh
docker exec -it -u root ${container_id_or_name} bash
```

### Vagrant

To use [Vagrant](https://www.vagrantup.com/), use:

```sh
BEAKER_HYPERVISOR=vagrant
```

To use [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt), use:

```sh
BEAKER_HYPERVISOR=vagrant_libvirt
```

The `Vagrantfile` for the created virtual machines will be in `.vagrant/beaker_vagrant_files`. From there you can use `vagrant ssh` as you normally would.

# Customizing host configuration

## Per host configuration

It is possible to use Puppet to set up an acceptance node. By default `spec/setup_acceptance_node.pp` is used if it exists. This can be changed. Use `false` to disable this behavior even if the file exists.

```ruby
RSpec.configure do |c|
  c.setup_acceptance_node = File.join('spec', 'setup_acceptance_node.pp')
end
```

This acceptance node setup script runs once per host once all other configuration is done.

It is also possible to do per host configuration by providing a block:

```ruby
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'os.name') == 'CentOS'
    install_package(host, 'epel-release')
  end
end
```

This block is executed after all host configuration is done except applying the acceptance node script.

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

## Environment variables to facts

It can be useful to provide facts via environment variables. A possible use is run the test suite with version 1.0 and 1.1. Often it's much easier to run the entire suite with version 1.0 and run it with 1.1 in a complete standalone fashion.

Voxpupuli-acceptance converts all environment variables starting with `BEAKER_FACTER_` and stores them in `/etc/facter/facts.d/voxpupuli-acceptance-env.json` on the target machine. All environment variables are converted to lowercase.

Given following `spec_helper_acceptance.rb` is used:

```ruby
require 'voxpupuli/acceptance/spec_helper_acceptance'

MANIFEST = <<PUPPET
class { 'mymodule':
  version => fact('mymodule_version'),
}
PUPPET

configure_beaker do |host|
  apply_manifest_on(host, MANIFEST, catch_failures: true)
end
```

Then it can be tested with:
```bash
BEAKER_FACTER_MYMODULE_VERSION=1.0 bundle exec rake beaker
BEAKER_FACTER_MYMODULE_VERSION=1.1 bundle exec rake beaker
```

Many CI systems make it easy to build a matrix with this.

If no environment variables are present, the file is removed. It is not possible to store structured facts.

This behavior can be disabled altogether:

```ruby
RSpec.configure do |c|
  c.suite_configure_facts_from_env = false
end
```

## Hiera

In many acceptance tests it's useful to override some defaults. For example, `configure_repository` should default to false in the module but is always on in acceptance tests. Hiera is a good tool for this and using [beaker-hiera](https://github.com/voxpupuli/beaker-hiera) it's easy and on by default.

To use this, create `spec/acceptance/hieradata` and use it as a regular Hiera data directory. It can be changed as follows. The defaults are shown:
```ruby
RSpec.configure do |c|
  c.suite_hiera = true
  c.suite_hiera_data_dir = File.join('spec', 'acceptance', 'hieradata')
  c.suite_hiera_hierachy = [
    'fqdn/%{fqdn}.yaml',
    'os/%{os.family}/%{os.release.major}.yaml',
    'os/%{os.family}.yaml',
    'common.yaml',
  ]
end
```

## Shared examples

Some [RSpec shared examples](https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples) are shipped by default. These make it easier to write tests.

### An idempotent resource

Often you want to test some manifest is idempotent. This means applying a manifest and ensuring there are no failures. It then applies again and ensures no changes were made.

```ruby
describe 'myclass' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include myclass
      PUPPET
    end
  end
end
```

### Examples

In modules there's the convention to have an examples directory. It's actually great to test these in acceptance. For this a shared example is available:

```ruby
describe 'my example' do
  it_behaves_like 'the example', 'my_example.pp'
end
```

For this `examples/my_example.pp' must exist and contain valid Puppet code. It then uses the idempotent resource shared example.
