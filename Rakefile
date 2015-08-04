require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
  config.disable_checks = ['80chars']
  config.fail_on_warnings = true
end

PuppetSyntax.exclude_paths = ["spec/fixtures/**/*.pp", "vendor/**/*"]

task :changelog do
  sh 'github_changelog_generator'
  if File.file? 'CHANGELOG.base.md'
    sh 'cat CHANGELOG.md CHANGELOG.base.md > CHANGELOG.new.md'
    sh 'mv CHANGELOG.new.md CHANGELOG.md'
  end
end
