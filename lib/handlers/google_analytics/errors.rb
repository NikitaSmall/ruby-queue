module Handlers
  module GoogleAnalytics
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
  end
end
