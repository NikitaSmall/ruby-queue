require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class LocationReportProcessResult
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument

        value_to_save = []
        options["location_report_rows"].each_with_index do |row, index|
          value_to_save << {
            "website_id" => options["profile"]["id"],
            "country" => row['ga:countryIsoCode'],
            "date" => row['ga:date'],
            "sessions" => row['ga:sessions'],
            "new_sessions" => row['ga:newUsers'],
            "pageviews" => row['ga:pageviews'],
            "avg_session" => row['ga:sessionDuration'],
            "bounce_rate" => row['ga:bounces'],
            "ga_region_id" => options["value_to_save"][index]["ga_region_id"],
            "ga_city_id" => options["value_to_save"][index]["id"]
           }
        end
        options.delete("location_report_rows")

        options["value_to_save"] = value_to_save
        options["model"] = 'LocationReport'
        options["target_handler"] = nil
        options["start_actor"] = GoogleAnalytics::LocationReport.name

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
