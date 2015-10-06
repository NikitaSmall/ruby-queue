require 'celluloid/current'

module Handlers
  module Adwords
    module KeywordStats
      class KeywordStats
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["columns"] = summary_columns

          options["report_type"] = 'KEYWORDS_PERFORMANCE_REPORT'
          options["report_name"] = 'Keyword report'

          options["target_handler"] = Adwords::KeywordStats::KeywordStatsParser.name

          task.argument = options.to_json
          run_task_request_for_campaigns(task)
        end

        private
        def run_task_request_for_campaigns(task)
          Celluloid::Actor[actor_name Adwords::StatsApiClient].run task
        end

        def summary_columns
          %w(AdGroupId
             Id
             Status
             Cost
             Clicks
             ConvertedClicks
             AveragePosition
             AverageCpc
             Ctr
             Date
             Impressions
             ConversionsManyPerClick
             FirstPageCpc
             TopOfPageCpc
             SearchImpressionShare
             Criteria)
        end

      end
    end
  end
end
