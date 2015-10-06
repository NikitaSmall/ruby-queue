require 'celluloid/current'

module Handlers
  module Adwords
    module Ad
      class Ad
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["fields"] = {fields: ['Id', 'AdGroupId', 'DisplayUrl', 'Headline', 'Status', 'Description1', 'Description2']}
          options["report_type"] = "AdGroupAdService"
          options["target_handler"] = Adwords::Ad::AdParser.name

          task.argument = options.to_json
          run_task_request_for_campaigns(task)
        end

        private
        def run_task_request_for_campaigns(task)
          Celluloid::Actor[actor_name Adwords::ApiClient].run task
        end

      end
    end
  end
end
