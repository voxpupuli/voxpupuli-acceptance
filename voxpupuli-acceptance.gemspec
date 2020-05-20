# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-acceptance'
  s.version     = '0.2.0'
  s.authors     = ['Vox Pupuli']
  s.email       = ['pmc@voxpupuli.org']
  s.homepage    = 'http://github.com/voxpupuli/voxpupuli-acceptance'
  s.summary     = 'Helpers for acceptance testing Vox Pupuli modules'
  s.description = 'A package that depends on all the gems Vox Pupuli modules need and methods to simplify acceptance spec helpers'
  s.licenses    = 'Apache-2.0'

  s.files       = Dir['lib/**/*.rb']

  # Testing
  s.add_runtime_dependency 'bcrypt_pbkdf'
  s.add_runtime_dependency 'beaker', '>= 4.2.0', '!= 4.22.0', '!= 4.23.0'
  s.add_runtime_dependency 'beaker-docker'
  s.add_runtime_dependency 'beaker-hostgenerator', '>= 1.1.22'
  s.add_runtime_dependency 'beaker-module_install_helper'
  s.add_runtime_dependency 'beaker-puppet'
  s.add_runtime_dependency 'beaker-puppet_install_helper'
  s.add_runtime_dependency 'beaker-rspec'
  s.add_runtime_dependency 'beaker-vagrant'
  s.add_runtime_dependency 'ed25519'
  s.add_runtime_dependency 'puppet-modulebuilder', '~> 0.1'
  s.add_runtime_dependency 'rbnacl', '>= 4'
  s.add_runtime_dependency 'rbnacl-libsodium'
  s.add_runtime_dependency 'serverspec'
  s.add_runtime_dependency 'winrm'
end
