require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProcessResult
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        profiles = JSON::parse options["profiles"]

        value_to_save = []
        profiles.each do |profile|
          value_to_save << { "name" => profile["name"], "external_id" => profile['id'], "industry" => profile['industryVertical'] }
        end

        options["value_to_save"] = value_to_save.to_json
        options["model"] = 'Website'

        task.argument = options.to_json
        run_task_save_results(task)
      end

      private
      def run_task_save_results(task)
        Celluloid::Actor[:result_saver].run task
      end
    end
  end
end
