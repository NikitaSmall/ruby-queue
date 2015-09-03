require File.join(File.dirname(__FILE__), 'config/enviroment.rb')
require File.join(File.dirname(__FILE__), 'lib/queue_manager.rb')

namespace :db do
  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
  end
end

desc "different queue checks"
namespace :check do
  task :new_tasks do
    manager = QueueManager.instance
    puts manager.new_tasks?
  end
end

namespace :do do
  desc "start processing new tasks"
  task :new do
    manager = QueueManager.instance
    manager.complete_new_tasks
  end
end
