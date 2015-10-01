require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Website
      class WebpropertiesParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]

          options["webproperties"] = response['items'].inject({}) { |memo, item|
            memo.update(item['id'] => item.fetch('industryVertical', 'UNSPECIFIED'))
          }
          options.delete("response")

          task.argument = options.to_json
          run_task_get_profiles(task)
        end

        private
        def run_task_get_profiles(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Website::ProfilesRequestPreparer] = GoogleAnalytics::Website::ProfilesRequestPreparer.new
          Celluloid::Actor[actor_name GoogleAnalytics::Website::ProfilesRequestPreparer].run task
        end
      end
    end
  end
end
