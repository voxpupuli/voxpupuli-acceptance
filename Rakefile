task :default do
end

begin
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix skip-changelog}
    config.user = 'voxpupuli'
    config.project = 'voxpupuli-acceptance'
    config.future_release = Gem::Specification.load("#{config.project}.gemspec").version
  end
rescue LoadError
end
