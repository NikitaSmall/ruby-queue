require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class GetProfiles
      include Celluloid

      def run(options, materialized_path)
        user = get_user(options["user_id"])
        profiles = user.profiles(JSON::parse(options["webproperties"]) )
        options["profiles"] = profiles.to_json

        create_task_process_result(options, materialized_path)
      end

      private
      def create_task_process_result(options, materialized_path)
        ::Task.create(handler: 'GoogleAnalytics::ProcessResult', argument: options.to_json, materialized_path: materialized_path)
      end

      def users
        @users ||= {}
      end

      def get_user(user_id)
        users[user_id] ||= Handlers::User.new(user_id)
      end
    end
  end
end
