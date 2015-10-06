require 'celluloid/current'

module Handlers
  module Adwords
    module AdStats
      class AdStatsProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("ad_stats").map do |row|
            {
              "ad_group_id" => row["Ad group ID"],
              "adwords_ad_id" => row["Ad ID"],
              "date" => row["Day"],
              "impressions" => row["Impressions"],
              "clicks" => row["Clicks"],
              "cost" => row["Cost"],
              "ctr" => row["CTR"],
              "conversions" => row["Conversions"],
              "average_position" => row["Avg. position"],
              "average_cost_per_click" => row["Avg. CPC"]
            }
          end

          options["model"] = 'AdwordsAdStat'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::AdStats::AdStats.name

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
