require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Referring
      class SourceProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          value_to_save = []
          options["reffering_report_rows"].each_with_index do |row, index|
            value_to_save << {
              "source" => row['ga:source'],
              "spam" => !(row['ga:source'] =~ /.*semalt\.com|.*makemoneyonline\.com|.*darodar\.com|.*ilovevitaly\.[co|com]|.*priceg\.com|.*buttons-for-website\.com|.*hulfingtonpost\.com|.*z2.zedo\.com|.*simple-share-button\.com/).nil?
             }
          end

          options["value_to_save"] = value_to_save
          options["model"] = 'GaReferrer'
          options["target_handler"] = GoogleAnalytics::Referring::ReferringProcessResult.name

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
