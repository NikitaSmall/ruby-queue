require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class GaCityProcessResult
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument

        value_to_save = []
        options["location_report_rows"].each_with_index do |row, index|
          value_to_save << {
            "name" => row["ga:city"],
            "latitude" => row['ga:latitude'],
            "longitude" => row['ga:longitude'],
            "external_id" => row['ga:cityId'],
            "ga_region_id" => options["value_to_save"][index]["id"]
          }
          options["value_to_save"][index]["region_id"] = options["value_to_save"][index]["id"]
        end

        options["value_to_save"] = value_to_save
        options["model"] = 'GaCity'
        options["target_handler"] = GoogleAnalytics::LocationReportProcessResult.name

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
