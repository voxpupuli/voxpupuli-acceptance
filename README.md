# Voxpupuli Acceptance Gem

[![License](https://img.shields.io/github/license/voxpupuli/voxpupuli-acceptance.svg)](https://github.com/voxpupuli/voxpupuli-acceptance/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/voxpupuli-acceptance/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/voxpupuli-acceptance/actions/workflows/ci.yml)
[![Release](https://github.com/voxpupuli/voxpupuli-acceptance/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/voxpupuli-acceptance/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)
[![RubyGem Downloads](https://img.shields.io/gem/dt/voxpupuli-acceptance.svg)](https://rubygems.org/gems/voxpupuli-acceptance)

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
BEAKER_SETFILE=centos7-64 bundle exec rake beaker
```

To list all known setfiles, you can run `bundle exec setfiles`.
That command is provided by [puppet_metadata](https://github.com/voxpupuli/puppet_metadata/blob/master/bin/setfiles), it will parse the local metadata.json and generate a list of supported setfiles based on the supported operating systems in the module.

Other common environment variables:

* `BEAKER_HYPERVISOR` defaults to `docker`, can be set to `vagrant_libvirt` or `vagrant` (using [VirtualBox](https://www.virtualbox.org/))
* `BEAKER_DESTROY` can be set to `no` to avoid destroying the box after completion. Useful to inspect failures. Another common value is `onpass` which deletes it only when the tests pass.
* `BEAKER_PROVISION` can be set to `no` to reuse a box. Note that the box must exist already. See `BEAKER_DESTROY`. Known to be broken with [beaker-docker](https://github.com/voxpupuli/beaker-docker).
* `BEAKER_SETFILE` is used to point to a setfile containing definitions. To avoid storing large YAML files in all repositories, [beaker-hostgenerator](https://github.com/voxpupuli/beaker-hostgenerator) is used to generate them on the fly when the file is not present.
* `BEAKER_PUPPET_COLLECTION` defines the puppet collection that will be configured, defaults to `puppet`. When set to `none`, no repository will be configured and distro package naming is assumed. When set to `preinstalled`, it assumes the OS is already set up with a collection but it still ensures `puppet-agent` is installed.
* `BEAKER_PUPPET_PACKAGE_NAME` optional env var to set the puppet agent package name. If not set, the package name will be determined using [puppet_metadata](https://github.com/voxpupuli/puppet_metadata#puppet_metadata).

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
    {
      name: "Per-node data",
      path: 'fqdn/%{facts.networking.fqdn}.yaml',
    },
    {
      name: 'OS family version data',
      path: 'family/%{facts.os.family}/%{facts.os.release.major}.yaml',
    },
    {
      name: 'OS family data',
      path: 'family/%{facts.os.family}.yaml',
    },
    {
      name: 'Common data',
      path: 'common.yaml',
    },
  ]
end
```

## Shared examples

Some [RSpec shared examples](https://rspec.info/features/3-12/rspec-core/example-groups/shared-examples/) are shipped by default. These make it easier to write tests.

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

For this `examples/my_example.pp` must exist and contain valid Puppet code. It then uses the idempotent resource shared example.

## Serverspec extensions

Some [Serverspec](https://serverspec.org/) extensions are shipped and enabled by default. These make it easier to write tests but were not accepted by Serverspec upstream.

### `curl_command`

Often you want to test some service that exposes things over HTTP.
Instead of using [`command("curl …")`](https://serverspec.org/resource_types.html#command) you can use `curl_command(…)` which behaves like a Serverspec `command` but adds matchers for the HTTP response code and the response body.

```ruby
describe curl_command("http://localhost:8080/api/ping") do
  its(:response_code) { is_expected.to eq(200) }
  its(:exit_status) { is_expected.to eq 0 }
end

describe curl_command('http://localhost:8080/api/status', headers: { 'Accept' => 'application/json' }) do
  its(:response_code) { is_expected.to eq(200) }
  its(:body_as_json) { is_expected.to eq({'status': 'ok'}) }
end
```
