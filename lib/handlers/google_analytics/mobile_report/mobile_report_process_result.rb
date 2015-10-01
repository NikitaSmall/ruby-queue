require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileReport
      class MobileReportProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options.delete("mobile_report_rows").each_with_index do |row, index|
            value_to_save << {
              "website_id" => options["profile"]["id"],
              "date" => row['ga:date'],
              "visits" => row['ga:pageviews'],
              "device" => row['ga:deviceCategory']
             }
          end          

          options["value_to_save"] = value_to_save
          options["model"] = 'MobileReport'
          options["target_handler"] = nil
          options["start_actor"] = GoogleAnalytics::MobileReport::MobileReport.name

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
