class Task < ActiveRecord::Base
  def doing
    self.attempts += 1
    self.status = "doing"
    save
  end

  def finished
    self.status = "done"
    save
  end

  def failed(e)
    self.status = "failed"
    self.last_error = e.message
    self.failed_at = Time.now
    save
  end
end
