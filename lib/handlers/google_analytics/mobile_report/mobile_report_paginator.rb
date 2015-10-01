require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileReport
      class MobileReportPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          while options["params"]['start-index'] + ApiFactory::GA_MAX_RESULTS <= response["totalResults"]
            options["params"]['start-index'] += ApiFactory::GA_MAX_RESULTS
            options["target_handler"] = GoogleAnalytics::MobileReport::MobileReportParser.name

            task.argument = options.to_json
            run_task_request_for_mobile_report(task) # to catch all the results
          end

          task.argument = options.to_json
          run_task_mobile_report_parser(task)
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportParser] = GoogleAnalytics::MobileReport::MobileReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::MobileReport::MobileReportParser].run task
        end

        def run_task_request_for_mobile_report(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
        end

        def headers(response)
          response['columnHeaders'].map { |header| header["name"] }
        end
      end
    end    
  end
end
