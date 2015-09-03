require File.join(File.dirname(__FILE__), 'config/enviroment.rb')
require File.join(File.dirname(__FILE__), 'lib/broker.rb')

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
