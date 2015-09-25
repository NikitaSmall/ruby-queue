require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class GetProfiles
      include Celluloid

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        user = get_user(options["user_id"])
        # В БД за данными пользователя нужно ходить только один раз
        # все данные для авторизации этот актор должен получить  качетсве аргументов
        profiles = user.profiles(JSON::parse(options["webproperties"]) )
        options["profiles"] = profiles.to_json

        create_task_process_result(options, task.new_materialized_path)
      end

      private
      def create_task_process_result(options, materialized_path)
        ::Task.create(handler: 'GoogleAnalytics::ProcessResult', argument: options.to_json, materialized_path: materialized_path, channel: options["channel"])
      end

      def users
        @users ||= {}
      end

      def get_user(user_id)
        users[user_id] ||= Handlers::GoogleAnalytics::User.new(user_id)
      end
    end
  end
end
