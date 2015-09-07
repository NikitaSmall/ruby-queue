class Task < ActiveRecord::Base
  def doing
    Task.update(id, attempts: attempts + 1, status: "doing")
  end

  def finished
    Task.update(id, status: "done")
  end

  def failed(e)
    Task.update(id, status: "failed", last_error: e.message, failed_at: Time.now)
  end
end
