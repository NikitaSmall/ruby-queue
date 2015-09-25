module Handlers
  class User
    # Этот пользователь относится исключительно к google analytics. Почему он не в неймспейсе?
    attr_accessor :analytics_access_token, :analytics_refresh_token, :analytics_token_issued_at, :darkwing_user_id

    def initialize(darkwing_user_id)
      @darkwing_user = DarkwingUser.find darkwing_user_id
      self.darkwing_user_id = darkwing_user_id
      self.analytics_access_token = @darkwing_user.analytics_access_token
      self.analytics_refresh_token = @darkwing_user.analytics_refresh_token
      self.analytics_token_issued_at = Time.parse(@darkwing_user.analytics_token_issued_at)
    end

    def webproperties
      @webproperties ||= get_webproperties
    end

    def profiles(webproperties = nil)
      @profiles ||= get_profiles(webproperties)
    end

    def update_darkwing
      @darkwing_user.update(
        analytics_access_token: self.analytics_access_token,
        analytics_refresh_token: self.analytics_refresh_token,
        analytics_token_issued_at: self.analytics_token_issued_at
      )
    end

    private
    def get_webproperties
      api = ApiFactory.new.analytics_api(self)
      GoogleAnalytics::AnalyticsWebsitesReport.new(api).fetch_webproperties
    end

    def get_profiles(webproperties)
      api = ApiFactory.new.analytics_api(self)
      GoogleAnalytics::AnalyticsWebsitesReport.new(api).fetch_profiles(webproperties)
    end
  end
end

class DarkwingUser < ActiveRecord::Base
  self.table_name = 'users'
end
