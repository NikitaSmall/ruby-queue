require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProfilesToUserProcessResult
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument
        task.argument = options.to_json

        options["value_to_save"] = options["value_to_save"].map do |value_to_save|
          { "user_id" => options["user_id"], "website_id" => value_to_save["id"] }
        end
        options["model"] = 'UsersWebsite'
        options["target_handler"] = Ender.name

        task.argument = options.to_json
        run_task_save_results(task)
      end

      private
      def run_task_save_results(task)
        Celluloid::Actor[:result_saver].run task
      end
    end
  end
end
