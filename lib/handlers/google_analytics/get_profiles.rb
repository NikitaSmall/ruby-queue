require 'celluloid/current'

module Handlers
  class GetProfiles
    include Celluloid

    def run(options)
      user = get_user(options["user_id"])
      profiles = user.profiles(JSON::parse(options["webproperties"]) )
      options["profiles"] = profiles.to_json

      create_task_process_result(options)
    end

    private
    def create_task_process_result(options)
      ::Task.create(handler: 'ProcessResult', argument: options.to_json)
    end

    def users
      @users ||= {}
    end

    def get_user(user_id)
      users[user_id] ||= Handlers::User.new(user_id)
    end
  end
end
