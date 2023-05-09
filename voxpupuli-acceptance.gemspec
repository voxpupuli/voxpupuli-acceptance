# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-acceptance'
  s.version     = '1.2.1'
  s.authors     = ['Vox Pupuli']
  s.email       = ['pmc@voxpupuli.org']
  s.homepage    = 'https://github.com/voxpupuli/voxpupuli-acceptance'
  s.summary     = 'Helpers for acceptance testing Vox Pupuli modules'
  s.description = 'A package that depends on all the gems Vox Pupuli modules need and methods to simplify acceptance spec helpers'
  s.licenses    = 'Apache-2.0'

  s.files       = Dir['lib/**/*.rb']

  s.required_ruby_version = '>= 2.7', '< 4'

  # Testing
  s.add_runtime_dependency 'bcrypt_pbkdf'
  s.add_runtime_dependency 'beaker', '~> 4.33'
  s.add_runtime_dependency 'beaker-docker'
  s.add_runtime_dependency 'beaker-hiera', '~> 0.4'
  s.add_runtime_dependency 'beaker-hostgenerator', '>= 1.1.22'
  s.add_runtime_dependency 'beaker-module_install_helper'
  s.add_runtime_dependency 'beaker-puppet'
  s.add_runtime_dependency 'beaker-puppet_install_helper'
  s.add_runtime_dependency 'beaker-rspec'
  s.add_runtime_dependency 'beaker-vagrant'
  s.add_runtime_dependency 'puppet-modulebuilder', '~> 0.1'
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'rspec-github', '~> 2.0'
  s.add_runtime_dependency 'serverspec'
  s.add_runtime_dependency 'winrm'
  s.add_development_dependency 'puppetlabs_spec_helper', '>= 4.0.0'
end
