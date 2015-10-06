require 'celluloid/current'

module Handlers
  module Adwords
    module KeywordStats
      class KeywordStatsProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("keyword_stats").map do |row|
            {
              "ad_group_id"            => row["Ad group ID"],
              "adwords_keyword_id"     => row["Keyword ID"],
              "clicks"                 => row["Clicks"],
              "impressions"            => row["Impressions"],
              "cost"                   => row["Cost"],
              "conversions"            => row["Conversions"],
              "average_position"       => row["Avg. position"],
              "average_cost_per_click" => row["Avg. CPC"],
              "ctr"                    => row["CTR"],
              "first_page_cpc"         => row["First page CPC"],
              "top_of_page_cpc"        => row["Top of page CPC"],
              "impression_share"       => row["Search Impr. share"],
              "date"                   => row["Day"]
            }
          end

          options["model"] = 'AdwordsKeywordStat'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::KeywordStats::KeywordStats.name

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
