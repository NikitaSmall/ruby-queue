require 'celluloid/current'

module Handlers
  module Adwords
    module CampaignReport
      class CampaignReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("campaigns").map do |row|
            { "external_id" => row["id"], "name" => row["name"], "status" => row["status"], "customer_id" => options["value_to_select"][0]["id"] }
          end

          options["model"] = 'AdwordsSemCampaign'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::CampaignReport::CampaignReport.name

          task.argument = options.to_json
          run_task_save_results(task)
        end

        private
        def run_task_save_results(task)
          Celluloid::Actor[:result_saver].run task
        end

      end
    end
  end
end
