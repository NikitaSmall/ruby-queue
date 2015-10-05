require 'celluloid/current'

module Handlers
  class TaskManager
    include Celluloid
    include Handlers::ActorHelper

    def run(task)
      options = task.argument

      ActiveRecord::Base.connection_pool.with_connection do
        ::Task.update(task.id, status: task.status, attempts: task.attempts, last_error: task.last_error, failed_at: task.failed_at)
      end

      log "Task #{task.handler} changed status to #{task.status}"
    end

    private

  end
end
