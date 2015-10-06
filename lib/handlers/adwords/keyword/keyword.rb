require 'celluloid/current'

module Handlers
  module Adwords
    module Keyword
      class Keyword
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          options["fields"] = fields
          options["report_type"] = "AdGroupCriterionService"
          options["target_handler"] = Adwords::Keyword::KeywordParser.name

          task.argument = options.to_json
          run_task_request_for_campaigns(task)
        end

        private
        def run_task_request_for_campaigns(task)
          Celluloid::Actor[actor_name Adwords::ApiClient].run task
        end

        def fields
          {
              predicates: [
                  {field: 'CriteriaType', values: ['KEYWORD'], operator: 'EQUALS'},
                  {field: 'CriterionUse', values: ['NEGATIVE'], operator: 'NOT_EQUALS'}
              ],
              fields: ['Id', 'AdGroupId', 'KeywordText', 'Status']
          }
        end

      end
    end
  end
end
