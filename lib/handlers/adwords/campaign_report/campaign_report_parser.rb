require 'celluloid/current'

module Handlers
  module Adwords
    module CampaignReport
      class CampaignReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["campaigns"] =  options.delete("response")

          options["model"] = "Customer"
          options["value_to_select"] = [{ "customer_id" => options["customer_id"] }]
          options["target_handler"] = Adwords::CampaignReport::CampaignReportProcessResult.name

          task.argument = options.to_json
          run_task_get_customer_id(task)
        end

        private
        def run_task_get_customer_id(task)
          Celluloid::Actor[:database_selector].run task
        end

      end
    end
  end
end
