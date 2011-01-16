require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "spriter"
    gem.summary = %Q{pure ruby PNG spriting library}
    gem.description = %Q{Spriter is a pure ruby PNG spriting library. It can be used standalone or as a Rails plugin, see the readme for details.}
    gem.email = ["qzzzq1@gmail.com", "tyler.jennings@gmail.com"]
    gem.homepage = "http://github.com/aberant/spriter"
    gem.authors = ["aberant", "tjennings"]
    gem.add_development_dependency "rspec" #, ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec #=> :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "spittle #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
