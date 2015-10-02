require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileAndReferringReport
      class MobileAndReferringReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options.delete("response")

          unless response["rows"].nil?
            options["mobile_and_reffering_report_rows"] = response["rows"].map do |row|
              make_hash(options['headers'], row)
            end

            task.argument = options.to_json
            run_task_mobile_report_parser(task)
            run_task_referring_report_parser(task)
          end
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportParser] = GoogleAnalytics::MobileReport::MobileReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportParser].run task
        end

        def run_task_referring_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ReferringReport::ReferringReportParser] = GoogleAnalytics::ReferringReport::ReferringReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::ReferringReport::ReferringReportParser].run task
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
