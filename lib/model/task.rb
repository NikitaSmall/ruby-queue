require 'yaml'

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
end
