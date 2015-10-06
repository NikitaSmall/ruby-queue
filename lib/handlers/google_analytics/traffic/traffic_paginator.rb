require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Traffic
      class TrafficPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::Traffic::TrafficParser.name)

          task.argument = options.to_json
          run_task_mobile_report_parser(task)
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Traffic::TrafficParser] = GoogleAnalytics::Traffic::TrafficParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::Traffic::TrafficParser].run task
        end
      end
    end
  end
end
