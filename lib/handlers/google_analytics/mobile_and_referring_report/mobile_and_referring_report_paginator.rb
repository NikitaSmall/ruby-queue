require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileAndReferringReport
      class MobileAndReferringReportPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::MobileAndReferringReport::MobileAndReferringReportParser.name)

          task.argument = options.to_json
          run_task_mobile_report_parser(task)
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::MobileAndReferringReport::MobileAndReferringReportParser] = GoogleAnalytics::MobileAndReferringReport::MobileAndReferringReportParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::MobileAndReferringReport::MobileAndReferringReportParser].run task
        end
      end
    end
  end
end
