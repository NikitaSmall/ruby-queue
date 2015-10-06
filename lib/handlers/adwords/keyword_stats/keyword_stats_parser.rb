require 'celluloid/current'

module Handlers
  module Adwords
    module KeywordStats
      class KeywordStatsParser
        include Celluloid
        include Handlers::ActorHelper

        IGNORED_KEYWORD_IDS = [3_000_000, 3_000_004]

        def run(task)
          options = task.argument
          keyword_stats = options.delete("response").split("\n")[1..-2].join("\n")

          options["keyword_stats"] = CSV.parse(keyword_stats, headers: true).map{|i| Hash[i] }
          options["keyword_stats"] = options["keyword_stats"].delete_if { |stat| IGNORED_KEYWORD_IDS.include? stat['Keyword ID'].to_i }

          task.argument = options.to_json
          run_task_process_result task
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name Adwords::KeywordStats::KeywordStatsProcessResult] = Adwords::KeywordStats::KeywordStatsProcessResult.new
          Celluloid::Actor[actor_name Adwords::KeywordStats::KeywordStatsProcessResult].run task
        end

      end
    end
  end
end
