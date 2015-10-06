require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileAndReferring
      class MobileAndReferringParser
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
          Celluloid::Actor[actor_name GoogleAnalytics::Mobile::MobileParser] = GoogleAnalytics::Mobile::MobileParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::Mobile::MobileParser].run task
        end

        def run_task_referring_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Referring::ReferringParser] = GoogleAnalytics::Referring::ReferringParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::Referring::ReferringParser].run task
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
