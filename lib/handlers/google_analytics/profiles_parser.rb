require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProfilesParser
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument
        response = JSON::load(options["response"])

        webproperties = JSON::load(options["webproperties"])

        profiles = response['items'].map do |item|
          item.update('industryVertical' => webproperties.fetch(item.delete('webPropertyId'), 'UNSPECIFIED'))
        end

        options["profiles"] = profiles.to_json

        task.argument = options.to_json
        run_task_process_result(task)
      end

      private
      def run_task_process_result(task)
        Celluloid::Actor[actor_name GoogleAnalytics::ProcessResult] = GoogleAnalytics::ProcessResult.new
        Celluloid::Actor[actor_name GoogleAnalytics::ProcessResult].run task
      end

      def create_task_process_result(options, materialized_path, channel)
        ::Task.create(handler: GoogleAnalytics::ProcessResult.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
      end
    end
  end
end
