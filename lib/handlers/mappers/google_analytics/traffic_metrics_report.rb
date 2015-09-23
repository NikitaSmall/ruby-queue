module GAMapper
  class TrafficMetricsReport < GoogleAnalyticsReport
    # Per site metrics
    METRICS = %w(
                 ga:sessions
                 ga:pageviews
                 ga:newUsers
                 ga:bounces
                 ga:sessionDuration
                 ga:users
                )
    DIMENSIONS = %w(
                ga:date
                   )
  end
end
