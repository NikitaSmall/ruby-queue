module Handlers
  module GoogleAnalytics
    class User
      attr_accessor :analytics_access_token, :analytics_refresh_token, :analytics_token_issued_at, :darkwing_user_id

      def initialize(darkwing_user_id)
        @darkwing_user = DarkwingUser.find darkwing_user_id
        self.darkwing_user_id = darkwing_user_id
        self.analytics_access_token = @darkwing_user.analytics_access_token
        self.analytics_refresh_token = @darkwing_user.analytics_refresh_token
        self.analytics_token_issued_at = Time.parse(@darkwing_user.analytics_token_issued_at)

        @api = ApiFactory.new.analytics_api(self)
      end
    end
  end
end

class DarkwingUser < ActiveRecord::Base
  self.table_name = 'users'
end
