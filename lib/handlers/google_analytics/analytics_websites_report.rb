module GAMapper
  class AnalyticsWebsitesReport

    INITIAL_TIMEOUT = 1
    MAX_TIMEOUT = 64

    attr_reader :api

    def initialize(api)
      @api = api
    end

    def analytics
      @analytics ||=  ApiFactory.new.discover_google_api(api, 'analytics', 'v3')
    end

    def fetch_profiles(webproperties)
      profiles(webproperties)
    end

    def fetch_webproperties
      webproperties
    end

    private

    def webproperties
      api_method = analytics.management.webproperties.list
      params = { accountId: '~all', fields: 'items(id,industryVertical)' }
      response = request_api { @api.execute(api_method, params) }
      webproperties = response['items'].inject({}) { |memo, item|
        memo.update(item['id'] => item.fetch('industryVertical', 'UNSPECIFIED'))
      }

      webproperties
    end

    def profiles(webproperties)
      api_method = analytics.management.profiles.list
      params = { accountId: '~all', webPropertyId: '~all', fields: 'items(name,webPropertyId,id)'  }
      response = request_api{ @api.execute api_method, params }
      response['items'].map do |item|
        item.update('industryVertical' => webproperties.fetch(item.delete('webPropertyId'), 'UNSPECIFIED'))
      end
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

        raise AuthError.new(body['error']) if reason == 'authError'
        raise NoProfilesFound.new(body['error']) if reason == "insufficientPermissions"
        raise Exception.new("Daily limits: #{body}") if reason == "dailyLimitExceeded"

        STDERR.puts "That's OK, we catch this error, just debug #{response.inspect}"

        sleep timeout
        timeout *= 2
      end

      if ga_error
        raise ::GAMapper::MaxRetriesTimeoutError,
          "Report failed to return within the time limit set by max timeout (#{timeout}).\n
          headers: #{response.response_headers}\n body: response.body"
      end

      body
    end

    def get_profiles(account_id, web_property_id)
      api_method = analytics.management.profiles.list
      params = {accountId: account_id, webPropertyId: web_property_id}
      request_api{ api.execute api_method, params }
    end
  end
end
