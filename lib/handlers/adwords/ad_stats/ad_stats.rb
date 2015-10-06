require 'celluloid/current'

module Handlers
  module Adwords
    module AdStats
      class AdStats
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["columns"] = summary_columns

          options["report_type"] = 'AD_PERFORMANCE_REPORT'
          options["report_name"] = 'Ad report'

          options["target_handler"] = Adwords::AdStats::AdStatsParser.name

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
             Headline
             Description1
             Description2
             DisplayUrl
             Status
             Date
             AveragePosition
             AverageCpc
             Cost
             Clicks
             Ctr
             Impressions
             ConversionsManyPerClick)
        end

      end
    end
  end
end
