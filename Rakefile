require File.join(File.dirname(__FILE__), 'config/enviroment.rb')
require File.join(File.dirname(__FILE__), 'lib/broker.rb')
require File.join(File.dirname(__FILE__), 'lib/worker.rb')

require 'rspec/core/rake_task'
require 'dotenv/tasks'

task :default => :test
task :test => :spec

if !defined?(RSpec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = Dir['spec/**/*_spec.rb']
  end
end

namespace :db do
  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
  end
end

desc "server for tasks deployment"
namespace :serve do
  desc "simple serve for new tasks"
  task :new, [:port] do |task, args|
    args.with_defaults(port: 3000)
    broker = Broker.instance
    broker.start_serve args[:port]
  end
end

desc "namespace to start worker"
namespace :worker do
  desc "start to asking a server to get tasks"
  task :start, [:host, :port] do |task, args|
    args.with_defaults(host: 'localhost', port: 3000)
    Worker.new(args[:host], args[:port]).listen_for_task
  end
end
