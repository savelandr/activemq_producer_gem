require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rubygems/package_task'

rdoc_opts = ["--exclude", "unit_tests/"]
files = ["activemq_producer.rb", "CHANGELOG"]
desc "Default: run unit tests"
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.pattern = "unit_tests/tc_*.rb"
  t.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_files = files
end

update_spec = Gem::Specification.new do |spec|
  spec.author = "Bob Saveland"
  spec.email = "savelandr@aol.com"
  spec.homepage = "http://adsqa.office.aol.com"
  spec.platform = "java"
  spec.description = "ActiveMQ topic or queue producer for testing convenience"
  spec.summary = "ActiveMQ topic producer"
  spec.name = "activemq_producer"
  spec.version = "1.0.2"
  spec.require_path = "."
  spec.rdoc_options = rdoc_opts
  spec.files = files
  spec.test_files = Dir.glob('unit_tests/*')
  spec.add_dependency "jruby-activemq", ">= 5.10.0"
end

Gem::PackageTask.new(update_spec) do |spec|
end
