require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class WebpropertiesRequestPreparer
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        options["params"] = { accountId: '~all', fields: 'items(id,industryVertical)' }.to_json
        options["target_handler"] = 'GoogleAnalytics::WebpropertiesParser'
        options["category_name"] = 'webproperties'

        task.argument = options.to_json
        run_task_request_for_webproperties(task)
      end

      private
      def run_task_request_for_webproperties(task)
        Celluloid::Actor['GoogleAnalytics::ApiClient'.tableize.singularize.to_sym].run task
      end

      def create_task_get_profiles(task)
        ::Task.create(handler: 'GoogleAnalytics::ProfilesGetter', argument: options.to_json, materialized_path: materialized_path, channel: options["channel"])
      end

    end
  end
end
