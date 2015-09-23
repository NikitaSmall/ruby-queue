module GAMapper
  class MobileAndReferringReport < MergedReport
    class << self
      def merged_reports
        [MobileReport, TopReferringReport]
      end
    end
  end
end
