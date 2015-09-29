module Handlers
  module ActorHelper
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

    def metrics
      METRICS
    end

    def dimensions
      DIMENSIONS
    end

    def filters
      FILTERS
    end

    def actor_name(klass)
      klass.name.tableize.singularize.to_sym
    end

  end
end
