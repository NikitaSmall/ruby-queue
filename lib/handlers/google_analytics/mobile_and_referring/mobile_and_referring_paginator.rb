require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileAndReferring
      class MobileAndReferringPaginator
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          response = options.delete("response")
          options["headers"] = headers(response)
          options["rows"] = response["rows"]

          options["rows"] = wait_for_paginate_report(task, options, response["totalResults"])

          task.argument = options.to_json
          run_task_mobile_report_parser(task)
        end

        private
        def run_task_mobile_report_parser(task)
          Celluloid::Actor[actor_name GoogleAnalytics::MobileAndReferring::MobileAndReferringParser] = GoogleAnalytics::MobileAndReferring::MobileAndReferringParser.new
          Celluloid::Actor[actor_name GoogleAnalytics::MobileAndReferring::MobileAndReferringParser].run task
        end
      end
    end
  end
end
