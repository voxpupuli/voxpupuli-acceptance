begin
  # Fixtures can be needed because of spec_prep
  # spec_prep task is provided by puppetlabs_spec_helper
  require 'puppetlabs_spec_helper/tasks/fixtures'
rescue LoadError
  # we only need that during CI, so we rescue the LoadError
end
# provides the beaker rake task
require 'beaker-rspec/rake_task'
