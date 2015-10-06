require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TopContent
      class ContentPageProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options["top_report_report_rows"].each_with_index do |row, index|
            value_to_save << {
              "page_path" => row['ga:pagePath']
             }
          end

          options["value_to_save"] = value_to_save
          options["model"] = 'ContentPage'
          options["target_handler"] = GoogleAnalytics::TopContent::TopContentProcessResult.name
          options["start_actor"] = GoogleAnalytics::TopContent::TopContent.name

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
