require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "antisamy"
  gem.homepage = "http://github.com/washu/antisamy-ruby"
  gem.license = "MIT"
  gem.summary = %Q{AntiSamy implmentation for Ruby.}
  gem.description = %Q{
    AntiSamy is a library to clean user-supplied HTML/CSS. This gem is a port of the anti-samy framework created for OWASP (http://www.owasp.org/index.php/Category:OWASP_AntiSamy_Project)
    AntiSamy works by using a policy to removed any dangerous input you specify from attributes to tags. This gem is built using nokogiri
  }
  gem.email = "sal.scotto@gmail.com"
  gem.authors = ["Sal Scotto"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'nokogiri'
  gem.add_development_dependency 'nokogiri'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
