require 'celluloid/current'

module Handlers
  class ResultSaver
    include Celluloid

    def run(task)
      options = task.argument # expect that arguments stored as json hash

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
      begin
        Object.const_get(model).create(value_to_save)
      rescue ActiveRecord::RecordNotUnique # it should be a Website model!
        websites = Website.where(external_id: value_to_save.map { |website| website["external_id"] }).to_a
        websites.each do |website|
          Website.update(website.id, value_to_save.find { |val| val["external_id"].to_i == website.external_id })
        end
      end
    end

    def create_task_save_results(options, materialized_path)
      ::Task.create(handler: 'ResultSaver', argument: options.to_json, materialized_path: materialized_path, channel: options["channel"])
    end

    def save_user_to_website_relation(options, objects, task)
      options["model"] = 'UsersWebsite'
      website_ids = objects.map { |website| website.id }

      value_to_save = website_ids.map do |id|
        { "user_id" => options["user_id"], "website_id" => id }
      end

      options["value_to_save"] = value_to_save.to_json
      create_task_save_results(options, task.new_materialized_path)
    end
  end
end
