module Handlers
  class Task
    attr_accessor :id, :handler, :argument, :channel, :status, :materialized_path, :attempts, :last_error, :failed_at

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
      self.status = 'doing'
      self.attempts += 1
      Celluloid::Actor[:task_manager].run self
    end

    def finished
      self.status = 'done'
      Celluloid::Actor[:task_manager].run self
    end

    def failed(e)
      self.last_error = e.message
      self.failed_at = Time.now
      self.status = 'failed'
      Celluloid::Actor[:task_manager].run self
    end
  end
end
