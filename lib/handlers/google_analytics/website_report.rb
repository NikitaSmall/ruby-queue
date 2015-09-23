require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class WebsiteReport
      include Celluloid

      def run(options, task)
        user = get_user(options["user_id"])
        webproperties = user.webproperties
        options["webproperties"] = webproperties.to_json

        create_task_get_profiles(options, task.new_materialized_path)
      end

      private
      def create_task_get_profiles(options, materialized_path)
        ::Task.create(handler: 'GoogleAnalytics::GetProfiles', argument: options.to_json, materialized_path: materialized_path)
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
