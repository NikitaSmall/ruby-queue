module GAMapper
  class UsersReport  < GoogleAnalyticsReport
    METRICS = ['ga:users']

    def self.reduce_key(row)
      ["analytics", name.demodulize, row['user_id'], row['profile_id'], row['start_date'], row['end_date']].join(MapManager::REDUCER_KEY_DELIMITER)
    end

    def self.reduce_value(row)
      [row['users']]
    end

    def fetch(start_date, end_date, _ = 1)
      data = []
      end_date = Date.parse(end_date) if end_date.is_a? String
      presets.each do |preset|
        start_date =  end_date - preset
        response =  super(start_date, end_date)
        data << {'profile_id' => response.profile_info['profileId'], 'start_date' => start_date, 'end_date' => end_date, 'users' => response.totals.fetch("ga:users", 0).to_i}
      end
      data
    end

    def presets
      [7.days, 1.month, 1.year]
    end

    def self.allow_batch_load?
      false
    end
  end
end
