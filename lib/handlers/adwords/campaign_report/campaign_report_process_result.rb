require 'celluloid/current'

module Handlers
  module Adwords
    module CampaignReport
      class CampaignReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          options["db_customer_id"] = options.delete("value_to_select")[0]["id"]

          options["value_to_save"] = options.delete("campaigns").map do |row|
            { "external_id" => row["id"], "name" => row["name"], "status" => row["status"], "customer_id" => options["db_customer_id"] }
          end

          options["model"] = 'AdwordsSemCampaign'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::CampaignReport::CampaignReport.name

          task.argument = options.to_json
          run_task_save_results(task)

          unless options["include_children"] == false
            create_task_ad_group_report(options, task.new_materialized_path, task.channel)
            create_task_ad_report(options, task.new_materialized_path, task.channel)
          end
        end

        private
        def run_task_save_results(task)
          Celluloid::Actor[:result_saver].run task
        end

        def create_task_ad_group_report(options, materialized_path, channel)
          ::Task.create(handler: Adwords::AdGroupReport::AdGroupReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

        def create_task_ad_report(options, materialized_path, channel)
          ::Task.create(handler: Adwords::AdReport::AdReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

      end
    end
  end
end
