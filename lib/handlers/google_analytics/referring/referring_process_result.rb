require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Referring
      class ReferringProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options.delete("reffering_report_rows").each_with_index do |row, index|
            value_to_save << {
              "website_id" => options["profile"]["id"],
              "date" => row['ga:date'],
              "avg_time_on_site" => row['ga:sessionDuration'],
              "pageviews" => row['ga:pageviews'],
              "visits" => row['ga:sessions'],
              "bounce_rate" => row['ga:bounces'],
              "ga_referrer_id" => options["value_to_save"][index]["id"]
             }
          end

          options["value_to_save"] = value_to_save
          options["model"] = 'TopReferringReport'
          options["target_handler"] = nil

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
