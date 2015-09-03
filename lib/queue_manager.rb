require File.join(File.dirname(__FILE__), 'model/task.rb')

class QueueManager
  include Singleton

  def new_tasks?
    tasks = Task.where(status: 'new')
    tasks.count > 0
  end
end
