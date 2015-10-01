require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module TopContentReport
      class TopContentReport
        include Celluloid
        include Handlers::ActorHelper

        METRICS = %w(
                     ga:uniquePageviews
                     ga:pageviews
                     ga:timeOnPage
                     ga:bounces
                     ga:sessions
                     ga:exits
                    )
        DIMENSIONS = %w(
                    ga:date
                    ga:pagePath
                       )

        def metrics
          METRICS
        end

        def dimensions
          DIMENSIONS
        end

        def filters
          []
        end

        def run(task)
          options = task.argument
          options["start_index"] ||= 1

          options["params"] = query(options["start_date"], options["end_date"], options["start_index"], options["profile"]["id"])
          options["target_handler"] = GoogleAnalytics::TopContentReport::TopContentReportPaginator.name
          options["category_name"] = 'top_report'

          task.argument = options.to_json
          run_task_request_for_top_report_report(task)
        end

        private
        def run_task_request_for_top_report_report(task)
          Celluloid::Actor[actor_name GoogleAnalytics::ApiClient].run task
        end

        def query(start_date, end_date, start_index=1, profile_id)
          {
              'ids' => 'ga:' + profile_id,
              'start-date' => start_date.to_s,
              'end-date' => end_date.to_s,
              'max-results' => ApiFactory::GA_MAX_RESULTS,
              'start-index' => start_index
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
