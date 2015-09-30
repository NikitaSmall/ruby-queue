require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class GaRegionProcessResult
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument
        
        options["value_to_save"] = options["location_report_rows"].map do |row|
          { "name" => row["ga:region"], "country" => row["ga:countryIsoCode"] }
        end
        options["model"] = 'GaRegion'
        options["target_handler"] = GoogleAnalytics::GaCityProcessResult.name

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
