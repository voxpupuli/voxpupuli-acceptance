# Voxpupuli Acceptance Gem

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

It is also possible to do per host configuration

```ruby
require 'voxpupuli/acceptance/spec_helper'

configure_beaker do |host|
  if fact_on_host, 'os.name') == 'CentOS'
    install_package(host, 'epel-release')
  end
end
```

This module provides no rake helpers but leaves that to [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Commonly invoked as:

```bash
BEAKER_setfile=centos7-64 bundle exec rake beaker
```

Other common environment variables:

* `BEAKER_HYPERVISOR` defaults to `docker`, can be set to `vagrant_libvirt`
* `BEAKER_destroy` can be set to `no` to avoid destroying the box after completion. Useful to inspect failures
* `BEAKER_provision` can be set to `no` to reuse a box. Note that the box must exist already. See `BEAKER_destroy`
