require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TrafficMetrics
      class TrafficMetricsParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          log 'TrafficMetrics task started'
          options = task.argument
          traffic_report_rows = options["traffic_report_rows"].group_by { |row| row["ga:date"] }

          options["traffic_metrics_report_rows"] = traffic_report_rows.map do |date, row|
            row = row.inject { |hash, el| hash.merge(el) { |key, old_v, new_v| %w(ga:sessions ga:pageviews ga:newUsers ga:bounces ga:sessionDuration ga:users).include?(key) ? old_v.to_i + new_v.to_i : old_v }  }
            row.merge("pageview_per_visit" => (row["ga:pageviews"].to_f / row["ga:users"].to_f))
          end

          task.argument = options.to_json
          run_task_process_result(task)
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficMetrics::TrafficMetricsProcessResult] = GoogleAnalytics::TrafficMetrics::TrafficMetricsProcessResult.new
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficMetrics::TrafficMetricsProcessResult].run task
        end

        def headers(response)
          response['columnHeaders'].map { |header| header["name"] }
        end

        def make_hash(headers, row)
          hash = {}
          for i in 0...row.count
            hash[headers[i]] = row[i]
          end
          hash
        end
      end
    end
  end
end
