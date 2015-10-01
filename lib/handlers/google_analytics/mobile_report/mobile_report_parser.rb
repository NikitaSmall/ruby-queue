require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileReport
      class MobileReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options.delete("response")

          unless response["rows"].nil?
            options["mobile_report_rows"] = response["rows"].map do |row|
              make_hash(headers(response), row)
            end

            task.argument = options.to_json
            run_task_process_result(task)
          end
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
