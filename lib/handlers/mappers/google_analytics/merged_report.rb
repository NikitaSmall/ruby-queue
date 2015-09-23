module GAMapper
  class MergedReport < GoogleAnalyticsReport

    class << self
      def merged_reports
        []
      end

      def metrics
        merged_reports.flat_map(&:metrics).uniq
      end

      def dimensions
        merged_reports.flat_map(&:dimensions).uniq
      end

      def to_reduce_rows(row)
        merged_reports.map {|r| r.to_reduce_row(row) }
      end

      def to_reduce_row(row)
        raise "TrafficReport generate more than one row for reducers. Use .to_reduce_rows method or use one of merged classes (#{merged_reports.map(&:name).join(', ')}"
      end

    end
  end
end
