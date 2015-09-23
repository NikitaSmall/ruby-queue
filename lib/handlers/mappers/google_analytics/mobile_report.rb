module GAMapper
  class MobileReport < GoogleAnalyticsReport
    METRICS = %w(
                 ga:pageviews
                )
    DIMENSIONS = %w(
                ga:date
                ga:deviceCategory
                   )
  end
end
