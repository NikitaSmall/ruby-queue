require 'celluloid/current'

module Handlers
  module Adwords
    class StatsApiClient
      include Celluloid

      API_VERSION = :v201506

      def run(task)
        options = task.argument

        ActiveRecord::Base.connection_pool.with_connection { @api = ApiFactory.new.adwords_api options["customer_id"] }
        options["response"] = @api.report_utils(API_VERSION).download_report report_params(options)

        task.argument = options.to_json
        run_task_for_request_parsing(task, options["target_handler"])
      end

      private
      def report_params(options)
        if options["start_date"].nil? || options["end_date"].nil?
          {
            selector: {
              fields: options["columns"]
            },
            report_type: options["report_type"],
            report_name: options["report_name"],
            download_format: 'GZIPPED_CSV',
            date_range_type: 'LAST_7_DAYS',
            include_zero_impressions: false,
          }
        else
          {
            selector: {
              fields: options["columns"],
              date_range: {
                min: formatted_date(options["start_date"]),
                max: formatted_date(options["end_date"])
              }
            },
            report_type: options["report_type"],
            report_name: options["report_name"],
            download_format: 'GZIPPED_CSV',
            date_range_type: 'CUSTOM_DATE',
            include_zero_impressions: false,
          }
        end
      end

      def formatted_date(date)
        Date.parse(date).strftime("%Y%m%d").to_i
      end

      def actor_name(klass)
        klass.tableize.singularize.to_sym
      end

      def run_task_for_request_parsing(task, destination)
        Celluloid::Actor[actor_name destination] = Handlers.const_get(destination).new
        Celluloid::Actor[actor_name destination].run task
      end

    end
  end
end
