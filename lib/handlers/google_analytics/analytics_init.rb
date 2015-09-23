require 'celluloid/current'

module Handlers
  class AnalyticsInit
    include Celluloid

    def run(options)
      if options["report_types"] == 'Website'
        create_task_get_profiles_webproperties(options)
      else
        user = get_user(options["user_id"])

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
    def create_task_get_profiles_webproperties(options) # first part of profiles
      ::Task.create(handler: 'get_profiles_webproperties', argument: options.to_json)
    end

    def get_user(user_id)
      users[user_id] ||= GAMapper::User.new(user_id)
    end

    def users
      @users ||= {}
    end
  end
end
