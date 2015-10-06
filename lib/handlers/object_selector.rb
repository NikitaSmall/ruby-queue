require 'celluloid/current'

module Handlers
  class ObjectSelector
    include Celluloid

    def run(task)
      options = task.argument

      ActiveRecord::Base.connection_pool.with_connection do
        options["value_to_select"].each do |value_to_select|
          value_to_select["id"] = select_from(options["model"], value_to_select)
        end
      end

      task.argument = options.to_json
      run_task_for_procced_processing(task, options["target_handler"])
    end

    private
    def select_from(model, value_to_save)
      Object.const_get(model).where(value_to_save).first.id
    end

    def actor_name(klass)
      klass.tableize.singularize.to_sym
    end

    def run_task_for_procced_processing(task, destination)
      return task.finished if destination.nil?

      Celluloid::Actor[actor_name destination] = Handlers.const_get(destination).new
      Celluloid::Actor[actor_name destination].run task
    end
  end
end
