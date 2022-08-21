require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "bundler/setup"
require "fake_idp"
Dir.glob("lib/tasks/*.rake").each { |r| load r }

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
