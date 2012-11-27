require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format progress -c features"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [ :spec, :features ]
