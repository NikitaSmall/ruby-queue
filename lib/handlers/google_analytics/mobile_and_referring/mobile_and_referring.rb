require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module MobileAndReferring
      class MobileAndReferring
        include Celluloid
        include Handlers::ActorHelper

        METRICS = %w(
                      ga:sessions
                      ga:pageviews
                      ga:sessionDuration
                      ga:bounces
                    )
        DIMENSIONS = %w(
                      ga:date
                      ga:deviceCategory
                      ga:source
                       )

        FILTERS = []

        def run(task)
          log 'MobileAndReferring task sequence started'
          options = task.argument
          options["start_index"] ||= 1

          options["params"] = query_params(options)
          options["target_handler"] = GoogleAnalytics::MobileAndReferring::MobileAndReferringPaginator.name
          options["category_name"] = 'mobile_and_referring'

          task.argument = options.to_json
          run_task_request_for_mobile_report(task)
        end

        private
        def run_task_request_for_mobile_report(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
        end

        def query_params(options)
          {
              'ids' => 'ga:' + options["profile"]["id"],
              'start-date' => options["start_date"].to_s,
              'end-date' => options["end_date"].to_s,
              'max-results' => ApiFactory::GA_MAX_RESULTS,
              'start-index' => options["start_index"]
          }.tap do |parameters|
            %w(metrics dimensions filters).each do |method|
              parameters[method] = self.send(method).join(',') if self.send(method).any?
            end
          end
        end

      end
    end
  end
end
