require 'celluloid/current'

module Handlers
  module Adwords
    module Keyword
      class KeywordParser
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
          Celluloid::Actor[actor_name Adwords::Keyword::KeywordProcessResult] = Adwords::Keyword::KeywordProcessResult.new
          Celluloid::Actor[actor_name Adwords::Keyword::KeywordProcessResult].run task
        end

      end
    end
  end
end
