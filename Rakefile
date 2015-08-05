require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'github_changelog_generator/task'
require 'puppet_blacksmith'
require 'puppet_blacksmith/rake_tasks'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
  config.disable_checks = ['80chars']
  config.fail_on_warnings = true
end

PuppetSyntax.exclude_paths = ["spec/fixtures/**/*.pp", "vendor/**/*"]

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  m = Blacksmith::Modulefile.new
  config.future_release = m.version
  config.release_url = "https://forge.puppetlabs.com/#{m.author}/#{m.name}/%s"
end
