require 'celluloid/current'

module Handlers
  module Adwords
    module Ad
      class AdParser
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
          Celluloid::Actor[actor_name Adwords::Ad::AdProcessResult] = Adwords::Ad::AdProcessResult.new
          Celluloid::Actor[actor_name Adwords::Ad::AdProcessResult].run task
        end

      end
    end
  end
end
