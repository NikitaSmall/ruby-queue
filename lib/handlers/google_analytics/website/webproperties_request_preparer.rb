require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Website
      class WebpropertiesRequestPreparer
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["params"] = { accountId: '~all', fields: 'items(id,industryVertical)' }
          options["target_handler"] = GoogleAnalytics::Website::WebpropertiesParser.name # next handler after request to api
          options["category_name"] = 'webproperties'

          task.argument = options.to_json
          run_task_request_for_webproperties(task)
        end

        private
        def run_task_request_for_webproperties(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
        end
      end
    end
  end
end
