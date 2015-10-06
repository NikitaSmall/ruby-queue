require 'celluloid/current'

module Handlers
  module Adwords
    module AdStats
      class AdStatsParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument
          keyword_stats = options.delete("response").split("\n")[1..-2].join("\n")

          options["ad_stats"] = CSV.parse(keyword_stats, headers: true).map{|i| Hash[i] }

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::AdStats::AdStatsProcessResult] = Adwords::AdStats::AdStatsProcessResult.new
          Celluloid::Actor[actor_name Adwords::AdStats::AdStatsProcessResult].run task
        end

      end
    end
  end
end
