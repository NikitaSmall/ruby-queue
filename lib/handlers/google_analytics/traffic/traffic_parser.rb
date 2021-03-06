require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Traffic
      class TrafficParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          if options["rows"].nil?
            task.finished
          else
            options["traffic_report_rows"] = options.delete("rows").map do |row|
              make_hash(options['headers'], row)
            end

            task.argument = options.to_json
            run_task_traffic_metrics_report_parser(task)
            run_task_traffic_channel_report_parser(task)
          end
        end

        private
        def run_task_traffic_metrics_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficMetrics::TrafficMetricsParser] = GoogleAnalytics::TrafficMetrics::TrafficMetricsParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficMetrics::TrafficMetricsParser].run task
        end

        def run_task_traffic_channel_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficChannel::TrafficChannelParser] = GoogleAnalytics::TrafficChannel::TrafficChannelParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficChannel::TrafficChannelParser].run task
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
