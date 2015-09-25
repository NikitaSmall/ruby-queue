require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class WebpropertiesParser
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash
        response = JSON::load(options["response"])

        webproperties = response['items'].inject({}) { |memo, item|
          memo.update(item['id'] => item.fetch('industryVertical', 'UNSPECIFIED'))
        }

        options["webproperties"] = webproperties.to_json
        create_task_get_profiles(options, task.new_materialized_path, task.channel)
      end

      private
      def create_task_get_profiles(options, materialized_path, channel)
        ::Task.create(handler: 'GoogleAnalytics::ProfilesRequestPreparer', argument: options.to_json, materialized_path: materialized_path, channel: channel)
      end
    end
  end
end
