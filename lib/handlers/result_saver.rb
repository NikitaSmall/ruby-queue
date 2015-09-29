require 'celluloid/current'

module Handlers
  class ResultSaver
    include Celluloid

    def run(task)
      options = task.argument

      options["value_to_save"].each do |value_to_save|
        value_to_save["id"] = save(options["model"], options["value_to_save"])
      end

      task.argument = options.to_json
      run_task_for_procced_processing(task, options["target_handler"])
    end

    private
    def save(model, value_to_save)
      begin
        Object.const_get(model).create(value_to_save)
      rescue ActiveRecord::RecordNotUnique # it should be a Website model!
        websites = Website.where(external_id: value_to_save.map { |website| website["external_id"] }).to_a
        websites.each do |website|
          value = value_to_save.find { |val| val["external_id"].to_i == website.external_id }
          Website.update(website.id, name: value["name"], industry: value["industry"])
        end
      end
    end

    def actor_name(klass)
      klass.tableize.singularize.to_sym
    end

    def run_task_for_procced_processing(task, destination)
      Celluloid::Actor[actor_name destination] = Handlers.const_get(destination).new
      Celluloid::Actor[actor_name destination].run task
    end
  end
end
