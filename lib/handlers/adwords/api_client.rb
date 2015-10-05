require 'celluloid/current'

module Handlers
  module Adwords
    class ApiClient
      include Celluloid

      API_VERSION = :v201506

      def run(task)
        options = task.argument

        ActiveRecord::Base.connection_pool.with_connection { @api = ApiFactory.new.adwords_api options["customer_id"] }
        service = @api.service(options["report_type"].to_sym, API_VERSION)

        options["response"] = service.get(options["fields"].deep_symbolize_keys!)[:entries]

        task.argument = options.to_json
        run_task_for_request_parsing(task, options["target_handler"])
      end

      protected
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
