begin
  require 'puppetlabs_spec_helper/tasks/beaker'
rescue LoadError
  require 'beaker-rspec/rake_task'
end
