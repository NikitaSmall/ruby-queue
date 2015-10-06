require 'celluloid/current'

module Handlers
  module Adwords
    module Keyword
      class KeywordProcessResult
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["value_to_save"] = options.delete("keywords").map do |row|
            {
              "external_id"             => row["criterion"]["id"],
              "ad_group_id"             => row["ad_group_id"],
              "status"                  => row["user_status"],
              "name"                    => row["criterion"]["text"],
            }
          end

          options["model"] = 'AdwordsKeyword'
          options["target_handler"] = nil
          options["start_actor"] = Adwords::Keyword::Keyword.name

          task.argument = options.to_json
          run_task_save_results(task)
        end

        private
        def run_task_save_results(task)
          Celluloid::Actor[:result_saver].run task
        end

      end
    end
  end
end
