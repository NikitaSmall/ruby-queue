require 'celluloid/current'

module Handlers
  module GoogleAnalytics
    class ProfilesProcessResult
      include Celluloid
      include Handlers::ActorHelper

      def run(task)
        options = task.argument

        options["value_to_save"] = options["profiles"].map do |profile|
          {
            "name" => profile["name"],
            "external_id" => profile['id'],
            "industry" => profile['industryVertical']
          }
        end
        options["model"] = 'Website'
        options["target_handler"] = GoogleAnalytics::ProfilesToUserProcessResult.name

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
