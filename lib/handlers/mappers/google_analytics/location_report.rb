module GAMapper
  class LocationReport < GoogleAnalyticsReport
    METRICS = %w(
                ga:sessions
                ga:newUsers
                ga:pageviews
                ga:sessionDuration
                ga:bounces
                )
    DIMENSIONS = %w(
                ga:date
                ga:countryIsoCode
                ga:region
                ga:city
                ga:cityId
                ga:latitude
                ga:longitude
                   )
    FILTERS = ["ga:subContinent==Northern America"]


    class << self
      def reduce_key(row)
        parts = ["analytics", name.demodulize, row['user_id'], row['profile_id']]
        %w(ga:date ga:countryIsoCode ga:region ga:city ga:cityId).each do |dimension|
          parts << row[dimension]
        end
        parts.join(MapManager::REDUCER_KEY_DELIMITER)
      end

      def reduce_value(row)
        (%w(ga:latitude ga:longitude) + self.metrics).map { |dimension| row[dimension] }
      end

    end
  end
end

