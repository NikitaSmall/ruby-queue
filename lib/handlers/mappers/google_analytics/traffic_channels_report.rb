module GAMapper
  class TrafficChannelsReport < GoogleAnalyticsReport
    METRICS = %w(
                 ga:sessions
                 ga:pageviews
                 ga:sessionDuration
                 ga:bounces
                )
    DIMENSIONS = %w(
                ga:date
                ga:channelGrouping
                   )

  end

end
