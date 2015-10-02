require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TrafficReport
      class TrafficReportPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::TrafficReport::TrafficReportParser.name)

          task.argument = options.to_json
          run_task_mobile_report_parser(task)
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficReport::TrafficReportParser] = GoogleAnalytics::TrafficReport::TrafficReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::TrafficReport::TrafficReportParser].run task
        end
      end
    end
  end
end
