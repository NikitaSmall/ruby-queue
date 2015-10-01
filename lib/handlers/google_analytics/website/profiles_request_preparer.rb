require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Website
      class ProfilesRequestPreparer
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["params"] = { accountId: '~all', webPropertyId: '~all', fields: 'items(name,webPropertyId,id)'  }
          options["target_handler"] = GoogleAnalytics::Website::ProfilesParser.name # next handler after request to api
          options["category_name"] = 'profiles'

          task.argument = options.to_json
          run_task_request_for_profiles(task)
        end

        private
        def run_task_request_for_profiles(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ManagementApiClient].run task
        end
      end
    end
  end
end
