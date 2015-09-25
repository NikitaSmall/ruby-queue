require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class Website
      include Celluloid
      TOKEN_LIFETIME = 3600

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        user = get_user(options["user_id"])
        options["api"] = { application_name: ENV['GOOGLE_APP_NAME'], application_version: '1.0.0' }.to_json

        options["api_authorization"] = { token_credential_uri: URI.parse('https://accounts.google.com/o/oauth2/token'),
        authorization_uri: URI.parse('https://accounts.google.com/o/oauth2/auth'),
        client_id: ENV['ADWORDS_CLIENT_ID'],
        client_secret: ENV['ADWORDS_CLIENT_SECRET'],
        access_token: user.analytics_access_token,
        refresh_token: user.analytics_refresh_token,
        issued_at: user.analytics_token_issued_at,
        expires_in: TOKEN_LIFETIME,
        client_customer_id: ENV['ADWORDS_CLIENT_CUSTOMER_ID'] }.to_json

        task.argument = options.to_json
        run_task_get_webproperties(task)
      end

      private
      def run_task_get_webproperties(task)
        Celluloid::Actor['GoogleAnalytics::WebpropertiesRequestPreparer'.tableize.singularize.to_sym] = Handlers::GoogleAnalytics::WebpropertiesRequestPreparer.new
        Celluloid::Actor['GoogleAnalytics::WebpropertiesRequestPreparer'.tableize.singularize.to_sym].run task
        # ::Task.create(handler: 'GoogleAnalytics::WebpropertiesGetter', argument: options.to_json, materialized_path: materialized_path, channel: options["channel"])
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
