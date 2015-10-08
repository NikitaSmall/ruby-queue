require 'celluloid/current'

module Handlers
  class TaskIncrementer
    include Celluloid
    include Handlers::ActorHelper

    def run(task)
      options = task.argument

      ActiveRecord::Base.connection_pool.with_connection do
        ::Task.increment_counter(options["counter"].to_sym, options["id"])
      end

      log "Task ##{options["id"]} increment counter #{options["counter"]}"
    end


  end
end
