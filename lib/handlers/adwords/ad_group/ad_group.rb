require 'celluloid/current'

module Handlers
  module Adwords
    module AdGroup
      class AdGroup
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["fields"] = {fields: ['Id', 'Name', 'Status', 'CampaignId']}
          options["report_type"] = "AdGroupService"
          options["target_handler"] = Adwords::AdGroup::AdGroupParser.name

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
