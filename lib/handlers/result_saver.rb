require 'celluloid/current'

module Handlers
  class ResultSaver
    include Celluloid

    def run(task)
      options = task.argument

      options["value_to_save"].each do |value_to_save|
        value_to_save["id"] = save(options["model"], value_to_save)
      end

      task.argument = options.to_json
      run_task_for_procced_processing(task, options["target_handler"])
    end

    private
    def save(model, value_to_save)
      begin
        Object.const_get(model).create(value_to_save).id
      rescue ActiveRecord::RecordNotUnique # it should be a Website model!
        Website.where(external_id: value_to_save["external_id"].to_i).update_all(name: value_to_save["name"], industry: value_to_save["industry"])
        nil
      end
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
