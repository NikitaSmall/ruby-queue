require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Website
      class ProfilesParser
        include Celluloid
        include Handlers::ActorHelper

        def run(task)
          options = task.argument

          response = options.delete("response")
          webproperties = options.delete("webproperties")

          options["profiles"] = response['items'].map do |item|
            item.update('industryVertical' => webproperties.fetch(item.delete('webPropertyId'), 'UNSPECIFIED'))
          end

          task.argument = options.to_json
          run_task_process_result(task)

          # create a new task's branches
          profiles = options.delete("profiles")
          profiles.each do |profile|
            options["profile"] = profile
            create_task_location_report(options, task.new_materialized_path, task.channel)
            create_task_to_content_report(options, task.new_materialized_path, task.channel)
            create_task_mobile_and_referring_report(options, task.new_materialized_path, task.channel)
            create_task_traffic_report(options, task.new_materialized_path, task.channel)
          end
        end

        private
        def run_task_process_result(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Website::ProfilesProcessResult] = GoogleAnalytics::Website::ProfilesProcessResult.new
          Celluloid::Actor[actor_name GoogleAnalytics::Website::ProfilesProcessResult].run task
        end

        def create_task_traffic_report(options, materialized_path, channel)
          ::Task.create(handler: GoogleAnalytics::TrafficReport::TrafficReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

        def create_task_location_report(options, materialized_path, channel)
          ::Task.create(handler: GoogleAnalytics::LocationReport::LocationReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

        def create_task_mobile_and_referring_report(options, materialized_path, channel)
          ::Task.create(handler: GoogleAnalytics::MobileAndReferringReport::MobileAndReferringReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end

        def create_task_to_content_report(options, materialized_path, channel)
          ::Task.create(handler: GoogleAnalytics::TopContentReport::TopContentReport.name, argument: options.to_json, materialized_path: materialized_path, channel: channel)
        end
      end
    end
  end
end
