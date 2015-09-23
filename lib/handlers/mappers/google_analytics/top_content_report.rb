module GAMapper
  class TopContentReport < GoogleAnalyticsReport
    # Top content per site (eg. "/", "/blog", ...) (content metrics: Pageviews, unique visits, avg time)
    METRICS = %w(
                 ga:uniquePageviews
                 ga:pageviews
                 ga:timeOnPage
                 ga:bounces
                 ga:sessions
                 ga:exits
                )
    DIMENSIONS = %w(
                ga:date
                ga:pagePath
                   )

  end
end
