require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TopContentReport
      class TopContentReportPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::TopContentReport::TopContentReportParser.name)

          task.argument = options.to_json
          run_task_top_content_report_parser(task)
        end

        private
        def run_task_top_content_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TopContentReport::TopContentReportParser] = GoogleAnalytics::TopContentReport::TopContentReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::TopContentReport::TopContentReportParser].run task
        end
      end
    end
  end
end
