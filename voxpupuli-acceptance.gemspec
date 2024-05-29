# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-acceptance'
  s.version     = '3.2.0'
  s.authors     = ['Vox Pupuli']
  s.email       = ['pmc@voxpupuli.org']
  s.homepage    = 'https://github.com/voxpupuli/voxpupuli-acceptance'
  s.summary     = 'Helpers for acceptance testing Vox Pupuli modules'
  s.description = 'A package that depends on all the gems Vox Pupuli modules need and methods to simplify acceptance spec helpers'
  s.licenses    = 'Apache-2.0'

  s.files       = Dir['lib/**/*.rb']

  s.required_ruby_version = '>= 2.7', '< 4'

  # Testing
  s.add_runtime_dependency 'bcrypt_pbkdf', '~> 1.1'
  s.add_runtime_dependency 'beaker', '~> 6.0'
  s.add_runtime_dependency 'beaker-docker', '~> 2.1'
  s.add_runtime_dependency 'beaker-hiera', '~> 1.0'
  s.add_runtime_dependency 'beaker-hostgenerator', '~> 2.2'
  s.add_runtime_dependency 'beaker_puppet_helpers', '~> 1.3'
  s.add_runtime_dependency 'beaker-rspec', '~> 8.0', '>= 8.0.1'
  s.add_runtime_dependency 'beaker-vagrant', '~> 1.2'
  s.add_runtime_dependency 'puppet-modulebuilder', '~> 1.0'
  s.add_runtime_dependency 'rake', '~> 13.0', '>= 13.0.6'
  s.add_runtime_dependency 'rspec-github', '~> 2.0'
  s.add_runtime_dependency 'serverspec', '~> 2.42', '>= 2.42.2'
  s.add_runtime_dependency 'winrm', '~> 2.3', '>= 2.3.6'
  s.add_development_dependency 'puppetlabs_spec_helper', '>= 4.0.0', '< 8'
end
