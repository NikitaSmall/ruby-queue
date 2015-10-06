require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Location
      class LocationPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::Location::LocationParser.name)

          task.argument = options.to_json
          run_task_location_report_parser(task)
        end

        private
        def run_task_location_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Location::LocationParser] = GoogleAnalytics::Location::LocationParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::Location::LocationParser].run task
        end
      end
    end
  end
end
