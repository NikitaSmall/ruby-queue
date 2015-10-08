module Handlers
  class Task
    attr_accessor :id, :handler, :argument, :channel, :status, :materialized_path, :attempts, :last_error, :failed_at, :task_incrementer

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
      return if status == 'done'

      self.status = 'done'
      clone = self.dup
      materialized_path.each do |parent_task_id|
        clone.argument = { "counter" => "done_sub_task", "id" => parent_task_id }.to_json
        Celluloid::Actor[:task_incrementer].run clone
      end
      Celluloid::Actor[:task_manager].run self
    end

    def failed(e)
      self.last_error = e.message
      self.failed_at = Time.now
      self.status = 'failed'

      clone = self.dup
      materialized_path.each do |parent_task_id|
        clone.argument = { "counter" => "failed_sub_task", "id" => parent_task_id }.to_json
        Celluloid::Actor[:task_incrementer].run clone
      end
      Celluloid::Actor[:task_manager].run self
    end
  end
end
