module GAMapper
  class TopReferringReport < GoogleAnalyticsReport
    # Top referring sites per site (eg. "/", "/blog", ...) (referrer metrics: visits, pages/visit, avg time)
    METRICS = %w(
                 ga:sessions
                 ga:pageviews
                 ga:sessionDuration
                 ga:bounces
                )
    DIMENSIONS = %w(
                ga:date
                ga:source
                   )
  end
end
