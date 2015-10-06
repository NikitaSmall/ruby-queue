require 'celluloid/current'

module Handlers
  module Adwords
    module AdGroup
      class AdGroupParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["ad_groups"] =  options.delete("response")

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::AdGroup::AdGroupProcessResult] = Adwords::AdGroup::AdGroupProcessResult.new
          Celluloid::Actor[actor_name Adwords::AdGroup::AdGroupProcessResult].run task
        end

      end
    end
  end
end
