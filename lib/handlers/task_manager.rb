require 'celluloid/current'

module Handlers
  class TaskManager
    include Celluloid

    def run(task)
      options = task.argument

      ActiveRecord::Base.connection_pool.with_connection do
        ::Task.update(task.id, status: task.status, attempts: task.attempts, last_error: task.last_error, failed_at: task.failed_at)
      end
    end

    private

  end
end
