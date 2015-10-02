require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module ReferringReport
      class ReferringReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          log 'ReferringReport task started'
          options = task.argument
          reffering_report_rows = options["mobile_and_reffering_report_rows"].group_by { |row| row["ga:source"] }

          options["reffering_report_rows"] = []
          reffering_report_rows.each do |source, rows|
            groupped_date_rows = rows.group_by { |row| row["ga:date"] }
            options["reffering_report_rows"] += groupped_date_rows.map do |date, rows|
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
          Celluloid::Actor[actor_name GoogleAnalytics::ReferringReport::SourceProcessResult] = GoogleAnalytics::ReferringReport::SourceProcessResult.new
          Celluloid::Actor[actor_name GoogleAnalytics::ReferringReport::SourceProcessResult].run task
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
