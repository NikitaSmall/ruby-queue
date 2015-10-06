require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TopContent
      class TopContentProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options.delete("top_report_report_rows").each_with_index do |row, index|
            value_to_save << {
              "website_id" => options["profile"]["id"],
              "date" => row['ga:date'],
              "unique_views" => row['ga:uniquePageviews'],
              "time_on_page" => row['ga:timeOnPage'],
              "pageviews" => row['ga:pageviews'],
              "visits" => row['ga:sessions'],
              "exits" => row['ga:exits'],
              "bounce_rate" => row['ga:bounces'],
              "content_page_id" => options["value_to_save"][index]["id"]
             }
          end

          options["value_to_save"] = value_to_save
          options["model"] = 'TopContentReport'
          options["target_handler"] = nil
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
