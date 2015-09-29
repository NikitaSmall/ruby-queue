require 'yaml'

class Task < ActiveRecord::Base
  after_create :serve_materialized_path
  after_update :check_for_complete

  def argument
    JSON::load(self[:argument].gsub('=>', ':').gsub('nil', 'null'))
  end

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

  def new_materialized_path
    materialized_path + [id]
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

  def check_for_complete
    #update_parents_for_done_tasks
    #finished if status == 'doing' && done_sub_task == processing_sub_task && done_sub_task > 0
  end

  def serve_materialized_path
    update_parents_for_processing_tasks
  end

  def update_parents_for_done_tasks
    if status == 'done'
      Task.increment_counter(:done_sub_task, materialized_path) unless materialized_path.empty?
    end
  end

  def update_parents_for_processing_tasks
    Task.increment_counter(:processing_sub_task, materialized_path) unless materialized_path.empty?
  end
end
