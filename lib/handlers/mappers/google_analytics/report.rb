module GAMapper

  class GaError < Exception
    def initialize(error)
      @error = error
    end

    def to_s
      "Error #{@error['code']} - #{@error['message']} while getting user profiles"
    end
  end

  class NoProfilesFound < GaError; end
  class MaxRetriesTimeoutError < GaError; end
  class AuthError < GaError; end

  def self.get_reports(type, profile_id, user, start_date = nil, end_date = nil)
    api = ApiFactory.new.analytics_api(user)
    report_class(type).new(api, profile_id).fetch(start_date, end_date)
  end

  def self.report_class(type)
    GAMapper.const_get "#{type}Report"
  end

  class User
    attr_accessor :analytics_access_token, :analytics_refresh_token, :analytics_token_issued_at, :darkwing_user_id

    def initialize(darkwing_user_id)
      @darkwing_user = DarkwingUser.find darkwing_user_id
      self.darkwing_user_id = darkwing_user_id
      self.analytics_access_token = @darkwing_user.analytics_access_token
      self.analytics_refresh_token = @darkwing_user.analytics_refresh_token
      self.analytics_token_issued_at = Time.parse(@darkwing_user.analytics_token_issued_at)
    end

    def profiles
      @profiles ||= get_profiles
    end

    def update_darkwing
      @darkwing_user.update(
        analytics_access_token: self.analytics_access_token,
        analytics_refresh_token: self.analytics_refresh_token,
        analytics_token_issued_at: self.analytics_token_issued_at
      )
    end

    private

    def get_profiles
      api = ApiFactory.new.analytics_api(self)
      AnalyticsWebsitesReport.new(api).fetch
    end
  end

  class Website < ::Struct.new(:id, :name, :industryVertical)
    def initialize(attributes = {})
      attributes.each do |attr_name, value|
        send("#{attr_name}=", value) if respond_to? "#{attr_name}="
      end
    end

    def industry
      industryVertical || 'UNSPECIFIED'
    end

    def profiles

    end
  end


  class GoogleAnalyticsReport

    INITIAL_TIMEOUT = 1
    MAX_TIMEOUT = 16

    class << self
      def load_data(api, query)
        analytics = ApiFactory.new.discover_google_api(api, 'analytics', 'v3')
        timeout = INITIAL_TIMEOUT
        while timeout < MAX_TIMEOUT
          response = ApiResponse.new(api.execute(analytics.data.ga.get, query))

          return response if response.success?

          case response.error_reason
            when "insufficientPermissions" then raise NoProfilesFound.new(response.error)
            when "dailyLimitExceeded" then raise Exception.new("Daily limits: #{response.body}")
            when "userRateLimitExceeded" then STDERR.puts "userRateLimitExceeded. Sleep #{timeout}"
            else raise Exception.new("Unexpected error: #{response.body}, query: #{query}")
          end

          STDERR.puts "That's OK, we catch this error, just debug #{response.body}"

          sleep timeout
          timeout *= 2
        end

        raise ::GAMapper::MaxRetriesTimeoutError,
          "Report failed to return within the time limit set by max timeout (#{timeout}).\n
          headers: #{response.response_headers}\n body: response.body"
      end

      def reduce_key(row)
        parts = ["analytics", name.demodulize, row['user_id'], row['profile_id']]
        self.dimensions.each do |dimension|
          parts << row[dimension]
        end
        parts.join(MapManager::REDUCER_KEY_DELIMITER)
      end

      def reduce_value(row)
        self.metrics.map { |dimension| row[dimension] }
      end

      def to_reduce_row(row)
        reduce_value(row).unshift(reduce_key(row))
      end

      def to_reduce_rows(row)
        [to_reduce_row(row)]
      end

      def metrics
        self.const_defined?(:METRICS) ? self::METRICS : []
      end

      def dimensions
        self.const_defined?(:DIMENSIONS) ? self::DIMENSIONS : []
      end

      def filters
        self.const_defined?(:FILTERS) ? self::FILTERS : []
      end
    end

    def initialize(api, profile_id, user_id = nil)
      @api = api
      @profile_id = profile_id
      @user_id = user_id
    end

    def fetch(start_date, end_date, start_index=1)
      load_data(query_params(start_date, end_date, start_index))
    end

    def load_data(query)
      self.class.load_data(@api, query)
    end


    def query_params(start_date, end_date, start_index=1)
      {
          'ids' => 'ga:' + @profile_id,
          'start-date' => start_date.to_s,
          'end-date' => end_date.to_s,
          'max-results' => ApiFactory::GA_MAX_RESULTS,
          'start-index' => start_index
      }.tap do |parameters|
        %w(metrics dimensions filters).each do |method|
          parameters[method] = self.class.send(method).join(',') if self.class.send(method).any?
        end
      end
    end

    def self.allow_batch_load?
      true
    end

  end


end
