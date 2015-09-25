require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class WebsiteReport
      # Я понимаю, что суффикс Report тяжелое наследие vault, но от него нужно избавляться
      include Celluloid

      def run(options, task)
        user = get_user(options["user_id"])
        webproperties = user.webproperties
        # мы одсуждали, что все запросы к API должны выполняться отдельным атором (причем все запросы к одному сервису одним и тем же)
        # этот актор должен только подготовить  API запрос (включая данные для аутентификации)
        # передачу этой задачи не стоит делать через базу

        options["webproperties"] = webproperties.to_json

        create_task_get_profiles(options, task.new_materialized_path)
      end

      private
      def create_task_get_profiles(options, materialized_path)
        # ты теряешь channel при создании таска
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
