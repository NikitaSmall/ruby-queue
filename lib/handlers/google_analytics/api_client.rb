require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ApiClient
      include Celluloid

      INITIAL_TIMEOUT = 1
      MAX_TIMEOUT = 64

      def run(task)
        options = JSON::load(task.argument) # expect that arguments stored as json hash

        api = get_api(JSON::parse(options["api"]), JSON::parse(options["api_authorization"]))
        api_method = get_api_method(api, options)

        params = JSON::load(options["params"])
        response = request_api { api.execute(api_method, params) }
        options["response"] = response.to_json

        task.argument = options.to_json
        run_task_for_request_parsing(task, options["target_handler"])
      end

      private
      def run_task_for_request_parsing(task, destination)
        Celluloid::Actor[destination.tableize.singularize.to_sym] = Handlers.const_get(destination).new
        Celluloid::Actor[destination.tableize.singularize.to_sym].run task
      end

      def get_api(api, api_authorization)
        client = Google::APIClient.new(api)
        client.authorization = Signet::OAuth2::Client.new(api_authorization)

        client
      end

      def analytics(api)
        @analytics ||=  ApiFactory.new.discover_google_api(api, 'analytics', 'v3')
      end

      def get_api_method(api, options)
        category_name = options["category_name"]
        analytics(api).management.send(category_name).list # list of webproperties or profiles
      end

      def request_api(&block)
        timeout = INITIAL_TIMEOUT
        ga_error = false
        while timeout < MAX_TIMEOUT
          response = block.call

          body = JSON.parse response.body
          ga_error = response.status.to_i != 200
          break unless ga_error

          reason = body['error']["errors"][0]['reason'] rescue nil

          raise GoogleAnalytics::AuthError.new(body['error']) if reason == 'authError'
          raise GoogleAnalytics::NoProfilesFound.new(body['error']) if reason == "insufficientPermissions"
          raise Exception.new("Daily limits: #{body}") if reason == "dailyLimitExceeded"

          STDERR.puts "That's OK, we catch this error, just debug #{response.inspect}"

          sleep timeout
          timeout *= 2
        end

        if ga_error
          raise ::Handlers::GoogleAnalytics::MaxRetriesTimeoutError,
            "Report failed to return within the time limit set by max timeout (#{timeout}).\n
            headers: #{response.response_headers}\n body: response.body"
        end

        body
      end
    end
  end
end
