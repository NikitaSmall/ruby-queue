require 'celluloid/current'

module Handlers
  class SaveResult
    include Celluloid

    def run(options, task)
      value_to_save = JSON::parse options["value_to_save"]
      objects = save(options["model"], value_to_save)

      if options["model"] == 'Website'
        save_user_to_website_relation(options, objects, task)
      else
        task.finished
      end
    end

    private
    def save(model, value_to_save)
      Object.const_get(model).create(value_to_save)
    end

    def create_task_save_results(options, materialized_path)
      ::Task.create(handler: 'SaveResult', argument: options.to_json, materialized_path: materialized_path)
    end

    def save_user_to_website_relation(options, objects, task)
      options["model"] = 'UsersWebsite'
      website_ids = objects.map { |website| website.id }

      value_to_save = []
      website_ids.each do |id|
        value_to_save << { "user_id" => options["user_id"], "website_id" => id }
      end

      options["value_to_save"] = value_to_save.to_json
      create_task_save_results(options, task.new_materialized_path)
    end
  end
end
