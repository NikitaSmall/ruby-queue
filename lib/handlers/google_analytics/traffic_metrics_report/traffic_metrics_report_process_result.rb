require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TrafficMetricsReport
      class TrafficMetricsReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options.delete("traffic_metrics_report_rows").each_with_index do |row, index|
            value_to_save << {
              "website_id" => options["profile"]["id"],
              "date" => row['ga:date'],
              "bounce" => row['ga:bounces'],
              "visits" => row['ga:users'],
              "pageviews" => row['ga:pageviews'],
              "new_visits" => row['ga:newUsers'],
              "avg_time_on_site" => row['ga:sessionDuration'],
              "time_on_site" => row['ga:session'],
              "pageviews_per_visit" => row["pageview_per_visit"]
             }
          end

          options["value_to_save"] = value_to_save
          options["model"] = 'TrafficMetricsReport'
          options["target_handler"] = nil

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
