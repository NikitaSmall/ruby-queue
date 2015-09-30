require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class LocationReportParser
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument
        response = options.delete("response")

        unless response.nil?
          options["location_report_rows"] = response["rows"].map do |row|
            make_hash(options["headers"], row)
          end

          task.argument = options.to_json
          run_task_process_result(task)
        end
        # p 'response is nil'
      end

      private
      def run_task_process_result(task)
        Celluloid::Actor[actor_name GoogleAnalytics::GaRegionProcessResult] = GoogleAnalytics::GaRegionProcessResult.new
        Celluloid::Actor[actor_name GoogleAnalytics::GaRegionProcessResult].run task
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
