module GAMapper
  class TrafficReport < MergedReport
    class << self

      def merged_reports
        [TrafficChannelsReport, TrafficMetricsReport]
      end

    end
  end
end
