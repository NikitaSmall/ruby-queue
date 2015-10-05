require 'celluloid/current'

module Handlers
  module Adwords
    module AdReport
      class AdReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("ads").map do |row|
            {
              "external_id"             => row["ad"]["id"],
              "ad_group_id"             => row["ad_group_id"],
              "status"                  => row["status"],
              "headline"                => row["ad"]["headline"],
              "description_first_line"  => row["ad"]["description1"],
              "description_second_line" => row["ad"]["description2"],
              "link"                    => row["ad"]["display_url"]
            }
          end

          options["model"] = 'AdwordsAd'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::AdReport::AdReport.name

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
