require 'celluloid/current'

module Handlers
  module Adwords
    module AdReport
      class AdReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["ads"] =  options.delete("response")

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::AdReport::AdReportProcessResult] = Adwords::AdReport::AdReportProcessResult.new
          Celluloid::Actor[actor_name Adwords::AdReport::AdReportProcessResult].run task
        end

      end
    end
  end
end
