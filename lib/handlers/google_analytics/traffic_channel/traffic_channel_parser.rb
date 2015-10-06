require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TrafficChannel
      class TrafficChannelParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          log 'TrafficChannel task started'
          options = task.argument
          traffic_channel_report_rows = options["traffic_report_rows"].group_by { |row| row["ga:channelGrouping"] }

          options["traffic_channel_report_rows"] = []
          traffic_channel_report_rows.each do |channel, rows|
            groupped_date_rows = rows.group_by { |row| row["ga:date"] }
            options["traffic_channel_report_rows"] += groupped_date_rows.map do |date, rows|
              rows.inject do |hash, el|
                hash.merge(el) do |key, old_v, new_v|
                  %w(ga:sessions ga:pageviews ga:sessionDuration ga:bounces).include?(key) ? old_v.to_i + new_v.to_i : old_v
                end
              end
            end
          end

          task.argument = options.to_json
          run_task_process_result(task)
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficChannel::TrafficChannelProcessResult] = GoogleAnalytics::TrafficChannel::TrafficChannelProcessResult.new
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficChannel::TrafficChannelProcessResult].run task
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
