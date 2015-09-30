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

        options["value_to_save"] = options["value_to_save"].delete_if { |value| value["website_id"].nil? }
        options["model"] = 'UsersWebsite'
        
        options["target_handler"] = nil
        options["start_actor"] = GoogleAnalytics::Website.name

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
