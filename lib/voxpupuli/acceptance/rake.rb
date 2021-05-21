begin
  require 'puppetlabs_spec_helper/tasks/beaker'
  # Fixtures can be needed because of spec_prep
  require 'puppetlabs_spec_helper/tasks/fixtures'
rescue LoadError
  require 'beaker-rspec/rake_task'
end
