require 'celluloid/current'

module Handlers
    module MetaTasks
      class GeneralImport
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          create_task_google_analytics_website_import(options, task.new_materialized_path, task.channel)
          create_task_adwords_campaign_import(options, task.new_materialized_path, task.channel)
        end

        private
        def create_task_google_analytics_website_import(options, materialized_path, channel)
          ::Task.create(handler: GoogleAnalytics::Website::Website.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

        def create_task_adwords_campaign_import(options, materialized_path, channel)
          ::Task.create(handler: Adwords::Campaign::Campaign.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

      end
    end
end
