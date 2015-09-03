require 'json'
require File.join(File.dirname(__FILE__), 'model/task.rb')

require File.join(File.dirname(__FILE__), 'handlers/divider.rb')
require File.join(File.dirname(__FILE__), 'handlers/summ.rb')

class QueueManager
  include Singleton

  def new_tasks?
    tasks = Task.where(status: 'new')
    tasks.count > 0
  end

  # manager take only new tasks continiosly (without retry or something else)
  def complete_new_tasks
    while true do
      tasks = Task.where(status: 'new') # here we will need to implement batch query to select proper batch

      tasks.each do |task|
        options = JSON::load(task.argument) # expect that arguments stored as json hash
        handler = task.handler.split("_").collect(&:capitalize).join
        begin
          task.doing # change status, set new attempt number
          Handlers.const_get(handler).new(options).run

          task.finished
        rescue => e
          task.failed(e)
        end
      end

      if tasks.count > 0
        puts 'All tasks from this batch was completed'
      else
        puts 'No new tasks'
      end
      sleep(3)
    end
  end

end
