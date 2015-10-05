require 'celluloid/current'

module Handlers
  module Adwords
    module AdGroupReport
      class AdGroupReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("ad_groups").map do |row|
            { "external_id" => row["id"], "name" => row["name"], "status" => row["status"], "sem_campaign_id" => row["campaign_id"] }
          end

          options["model"] = 'AdwordsAdGroup'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::AdGroupReport::AdGroupReport.name

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
