require 'celluloid/current'

module Handlers
  module Adwords
    module AdGroupReport
      class AdGroupReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["ag_groups"] =  options.delete("response")

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::AdGroupReport::AdGroupReportProcessResult] = Adwords::AdGroupReport::AdGroupReportProcessResult.new
          Celluloid::Actor[actor_name Adwords::AdGroupReport::AdGroupReportProcessResult].run task
        end

      end
    end
  end
end
