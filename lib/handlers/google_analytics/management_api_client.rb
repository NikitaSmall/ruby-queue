require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ManagementApiClient < ApiClient
      include Celluloid

      private
      def api_method(api, options)
        category_name = options["category_name"]
        analytics(api).management.send(category_name).list # list of webproperties or profiles
      end
    end
  end
end
