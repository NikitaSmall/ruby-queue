require 'yaml'

class Task < ActiveRecord::Base
  after_create :serve_materialized_path

  def doing
    Task.update(id, attempts: attempts + 1, status: "doing")
  end

  def finished
    Task.update(id, status: "done")
  end

  def failed(e)
    Task.update(id, status: "failed", last_error: e.message, failed_at: Time.now)
  end

  def channel_config
    parse_config if @channel_config.nil?
    @channel_config
  end

  private
  def parse_config
    configs = YAML::load(File.open(File.join(File.dirname(__FILE__), '../../config/channels.yml')))

    if configs.key? channel
      @channel_config = configs[channel]
    else
      @channel_config = false
    end
  end

  def serve_materialized_path
    update_parents
    insert_in_materialized_path
  end

  def update_parents
    materialized_path.each do |id|
      task = Task.find(id)
      task.processing_sub_task += 1
      task.save
    end
  end

  def insert_in_materialized_path
    self.materialized_path << id
    save
  end
end
