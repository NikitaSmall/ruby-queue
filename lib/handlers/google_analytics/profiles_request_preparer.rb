require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProfilesRequestPreparer
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        options["params"] = { accountId: '~all', webPropertyId: '~all', fields: 'items(name,webPropertyId,id)'  }.to_json
        options["target_handler"] = 'GoogleAnalytics::ProfilesParser' # next handler after request to api
        options["category_name"] = 'profiles'

        task.argument = options.to_json
        run_task_request_for_profiles(task)
      end

      private
      def run_task_request_for_profiles(task)
        Celluloid::Actor['GoogleAnalytics::ApiClient'.tableize.singularize.to_sym].run task
      end
    end
  end
end
