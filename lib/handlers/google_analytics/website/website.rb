require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    module Website
      class Website
        include Celluloid
        include Handlers::ActorHelper

        TOKEN_LIFETIME = 3600

        def run(task)
          options = task.argument

          options["api"] = api_hash
          options["api_authorization"] = api_auth_hash(user(options["user_id"]))

          task.argument = options.to_json
          run_task_get_webproperties(task)
        end

        private

        def run_task_get_webproperties(task)
          Celluloid::Actor[actor_name GoogleAnalytics::Website::WebpropertiesRequestPreparer] = Handlers::GoogleAnalytics::Website::WebpropertiesRequestPreparer.new
          Celluloid::Actor[actor_name GoogleAnalytics::Website::WebpropertiesRequestPreparer].run task
        end

        def user(user_id)
          Handlers::GoogleAnalytics::User.new(user_id)
        end

        def api_hash
          { application_name: ENV['GOOGLE_APP_NAME'], application_version: '1.0.0' }
        end

        def api_auth_hash(user)
          { token_credential_uri: URI.parse('https://accounts.google.com/o/oauth2/token'),
          authorization_uri: URI.parse('https://accounts.google.com/o/oauth2/auth'),
          client_id: ENV['ADWORDS_CLIENT_ID'],
          client_secret: ENV['ADWORDS_CLIENT_SECRET'],
          access_token: user.analytics_access_token,
          refresh_token: user.analytics_refresh_token,
          issued_at: user.analytics_token_issued_at,
          expires_in: TOKEN_LIFETIME,
          client_customer_id: ENV['ADWORDS_CLIENT_CUSTOMER_ID'] }
        end
      end
    end
  end
end
