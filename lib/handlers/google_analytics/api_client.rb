require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ApiClient
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

      end

      private
      def create_task_process_result(options, materialized_path)
        ::Task.create(handler: 'GoogleAnalytics::ProcessResult', argument: options.to_json, materialized_path: materialized_path, channel: options["channel"])
      end

    end
  end
end
