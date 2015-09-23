require 'celluloid/current'

module GAMapper
  class AnalyticsMapper
    include Celluloid

    REDUCER_KEY_DELIMITER = '#_#_'

    def get_data(options) #user_id, report_types, start_date=nil, end_date=nil, profile=nil
      user = get_user(options["user_id"])

      if options["report_types"] == 'Website'
        user.profiles.each do |profile|
          mapper_args = ["analytics", "Website", options["user_id"], profile['id'], profile['name'], profile['industryVertical']]
          MapManager.instance.process_result mapper_args.join(MapManager::REDUCER_KEY_DELIMITER)
        end
      else
        api = ApiFactory.new.analytics_api user
        # Separate reports for websites
        options["report_types"].split(',').each do |report_type|
          report = report_instance(report_type, api, options["profile"])
          start_index = 1

          begin
            response = report.fetch options["start_date"], options["end_date"], start_index

            response.each do |row|
              row['profile_id'] = profile
              row['user_id'] = user_id
              report.class.to_reduce_rows(row).each do |reduce_row|
                MapManager.instance.process_result *reduce_row
              end
            end

            start_index = start_index + ApiFactory::GA_MAX_RESULTS
            STDERR.puts "fetching from #{start_index}"
          end while response.respond_to?(:total_results) && start_index <= response.total_results

        end
      end
    rescue GAMapper::NoProfilesFound => e
      STDERR.puts "User ##{options["user_id"]} don't have Google Analytics profile"
    end

    private

    def get_profile_data(report_type, profile_id, user, start_date, end_date)
      GAMapper.get_reports(report_type, profile_id, user, start_date, end_date)[:rows]
    end

    def users
      @users ||= {}
    end

    def get_user(user_id)
      users[user_id] ||= GAMapper::User.new(user_id)
    end

    def report_class(report_type)
      GAMapper.report_class(report_type)
    end

    def report_instance(report_type, api, profile_id)
      report_class(report_type).new(api, profile_id)
    end
  end
end
