require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProfilesParser
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash
        response = JSON::load(options["response"])

        webproperties = JSON::load(options["webproperties"])

        profiles = response['items'].map do |item|
          item.update('industryVertical' => webproperties.fetch(item.delete('webPropertyId'), 'UNSPECIFIED'))
        end

        options["profiles"] = profiles.to_json
        create_task_process_result(options, task.new_materialized_path, task.channel)
      end

      private
      def create_task_process_result(options, materialized_path, channel)
        ::Task.create(handler: 'GoogleAnalytics::ProcessResult', argument: options.to_json, materialized_path: materialized_path, channel: channel)
      end
    end
  end
end
