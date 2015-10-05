require 'celluloid/current'

module Handlers
  module Adwords
    module KeywordReport
      class KeywordReportParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["keywords"] =  options.delete("response")

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::KeywordReport::KeywordReportProcessResult] = Adwords::KeywordReport::KeywordReportProcessResult.new
          Celluloid::Actor[actor_name Adwords::KeywordReport::KeywordReportProcessResult].run task
        end

      end
    end
  end
end
