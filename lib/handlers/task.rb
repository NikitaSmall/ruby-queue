module Handlers
  class Task
    attr_accessor :id, :handler, :argument, :channel, :status, :materialized_path, :attempts

    def initialize(hash)
      @id = hash["id"]
      @handler = hash["handler"]
      @argument = hash["argument"]
      @channel = hash["channel"]
      @status = hash["status"]
      @materialized_path = hash["materialized_path"]
      @attempts = hash["attempts"]
    end

    def argument
      return JSON::load(@argument.gsub('=>', ':').gsub('nil', 'null')) if @argument.is_a? String
      @argument
    end

    def new_materialized_path
      @materialized_path + [@id]
    end

    def doing
      ::Task.update(@id, attempts: @attempts + 1, status: "doing")
    end

    def finished
      ::Task.update(@id, status: "done")
    end

    def failed(e)
      ::Task.update(@id, status: "failed", last_error: e.message, failed_at: Time.now)
    end
  end
end
