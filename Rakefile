require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

begin
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix skip-changelog github_actions}
    config.user = 'voxpupuli'
    config.project = 'voxpupuli-acceptance'
    config.future_release = Gem::Specification.load("#{config.project}.gemspec").version
  end
rescue LoadError
end

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end
