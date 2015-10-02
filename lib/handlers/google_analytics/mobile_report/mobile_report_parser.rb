require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileReport
      class MobileReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          mobile_report_rows = options["mobile_and_reffering_report_rows"].group_by { |row| row["ga:deviceCategory"] }

          options["mobile_report_rows"] = []
          mobile_report_rows.each do |deviceCategory, rows|
            groupped_date_rows = rows.group_by { |row| row["ga:date"] }
            options["mobile_report_rows"] += groupped_date_rows.map do |date, rows|
              rows.inject { |hash, el| hash.merge(el) { |key, old_v, new_v| key == "ga:pageviews" ? old_v.to_i + new_v.to_i : old_v }  }
            end
          end

          task.argument = options.to_json
          run_task_process_result(task)
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportProcessResult] = GoogleAnalytics::MobileReport::MobileReportProcessResult.new
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportProcessResult].run task
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
