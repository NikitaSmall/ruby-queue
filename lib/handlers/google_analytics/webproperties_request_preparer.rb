require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class WebpropertiesRequestPreparer
      include Celluloid

      def run(task)
        options = task.argument

        options["params"] = { accountId: '~all', fields: 'items(id,industryVertical)' }.to_json
        options["target_handler"] = GoogleAnalytics::WebpropertiesParser.name # next handler after request to api
        options["category_name"] = 'webproperties'

        task.argument = options.to_json
        run_task_request_for_webproperties(task)
      end

      private
      def actor_name(klass)
        klass.name.tableize.singularize.to_sym
      end

      def run_task_request_for_webproperties(task)
        Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
      end
    end
  end
end
