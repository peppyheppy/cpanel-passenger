require 'rubygems' unless ENV['NO_RUBYGEMS']
%w[rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/cpanel_passenger'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('cpanel-passenger', CpanelPassenger::VERSION) do |p|
  p.developer('Paul Hepworth', 'paul@peppyheppy.com')
  # p.extra_deps         = [
  #   ['activesupport','>= 2.0.2'],
  # ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# task :default => [:spec, :features]
