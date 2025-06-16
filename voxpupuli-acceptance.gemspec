# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-acceptance'
  s.version     = '3.7.0'
  s.authors     = ['Vox Pupuli']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'https://github.com/voxpupuli/voxpupuli-acceptance'
  s.summary     = 'Helpers for acceptance testing Vox Pupuli modules'
  s.description = 'A package that depends on all the gems Vox Pupuli modules need and methods to simplify acceptance spec helpers'
  s.licenses    = 'Apache-2.0'

  s.files       = Dir['lib/**/*.rb']

  s.required_ruby_version = '>= 2.7', '< 4'

  # Testing
  s.add_dependency 'bcrypt_pbkdf', '~> 1.1'
  s.add_dependency 'beaker', '~> 6.0'
  s.add_dependency 'beaker-docker', '~> 2.1'
  s.add_dependency 'beaker-hiera', '~> 1.0'
  s.add_dependency 'beaker-hostgenerator', '~> 2.2'
  s.add_dependency 'beaker_puppet_helpers', '~> 2.2'
  s.add_dependency 'beaker-rspec', '~> 8.0', '>= 8.0.1'
  s.add_dependency 'beaker-vagrant', '~> 1.2'
  s.add_dependency 'puppet_fixtures', '>= 0.1', '< 2'
  s.add_dependency 'puppet-modulebuilder', '~> 2.0', '>= 2.0.2'
  s.add_dependency 'rake', '~> 13.0', '>= 13.0.6'
  s.add_dependency 'rspec-github', '~> 2.0'
  s.add_dependency 'serverspec', '~> 2.42', '>= 2.42.2'
  s.add_dependency 'winrm', '~> 2.3', '>= 2.3.6'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 3.1.0'
end
