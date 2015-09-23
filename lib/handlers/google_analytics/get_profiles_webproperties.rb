require 'celluloid/current'

module Handlers
  class GetProfilesWebproperties
    include Celluloid

    def run(options)
      user = get_user(options["user_id"])
      webproperties = user.webproperties
      options["webproperties"] = webproperties.to_json

      create_task_get_profiles(options)
    end

    private
    def create_task_get_profiles(options)
      ::Task.create(handler: 'get_profiles', argument: options.to_json)
    end

    def users
      @users ||= {}
    end

    def get_user(user_id)
      users[user_id] ||= GAMapper::User.new(user_id)
    end
  end
end
