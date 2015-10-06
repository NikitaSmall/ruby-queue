require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TopContent
      class TopContentPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options["response"]
          options["headers"] = headers(response)

          paginate_report(task, options, response["totalResults"], GoogleAnalytics::TopContent::TopContentParser.name)

          task.argument = options.to_json
          run_task_top_content_report_parser(task)
        end

        private
        def run_task_top_content_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::TopContent::TopContentParser] = GoogleAnalytics::TopContent::TopContentParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::TopContent::TopContentParser].run task
        end
      end
    end
  end
end
