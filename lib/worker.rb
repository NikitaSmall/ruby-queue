require 'json'
require 'socket'

require 'celluloid/current'
require 'retriable'

require File.join(File.dirname(__FILE__), 'model/task.rb')
require File.join(File.dirname(__FILE__), 'model/darkwing_stubs.rb')

require File.join(File.dirname(__FILE__), 'handlers/actor_helper.rb')
require File.join(File.dirname(__FILE__), 'handlers/result_saver.rb')
require File.join(File.dirname(__FILE__), 'handlers/api_factory.rb')
require File.join(File.dirname(__FILE__), 'handlers/ender.rb')
require File.join(File.dirname(__FILE__), 'handlers/task.rb')
require File.join(File.dirname(__FILE__), 'handlers/task_manager.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/api_client.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/management_api_client.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/user.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/errors.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/location_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/ga_city_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/ga_region_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/location_report_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/location_report_paginator.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/location_report/location_report.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_report/traffic_report.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_report/traffic_report_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_report/traffic_report_paginator.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_metrics_report/traffic_metrics_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_metrics_report/traffic_metrics_report_parser.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_channel_report/traffic_channel_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/traffic_channel_report/traffic_channel_report_parser.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/mobile_and_referring_report/mobile_and_referring_report_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/mobile_and_referring_report/mobile_and_referring_report_paginator.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/mobile_and_referring_report/mobile_and_referring_report.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/referring_report/referring_report_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/referring_report/referring_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/referring_report/source_process_result.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/mobile_report/mobile_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/mobile_report/mobile_report_parser.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/top_content_report/top_content_report_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/top_content_report/content_pages_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/top_content_report/top_content_report_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/top_content_report/top_content_report_paginator.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/top_content_report/top_content_report.rb')

require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/profiles_to_user_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/profiles_process_result.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/profiles_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/profiles_request_preparer.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/webproperties_parser.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/webproperties_request_preparer.rb')
require File.join(File.dirname(__FILE__), 'handlers/google_analytics/website/website.rb')

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))
REDUCER_KEY_DELIMITER = '#_#_'

class Worker
  # include Celluloid
  attr_accessor :task, :host, :port
  TIME_TO_IDLE = 10 # seconds wait for a new task or server restoring (if an error was occured)

  def initialize(host, port, logfile = 'logs/logfile.log')
    @task = nil
    @host = host
    @port = port

    @logger_to_file = Logger.new(logfile)

    register_actor_pools
  end

  def listen_for_task
    log "worker started"
    loop do
      if task = next_task
        process task
      else
        wait_for_task
      end
    end
  end

  private
  def next_task
    message = ask_for_task
    return parse(message) if message_is_task? message
    nil
  end

  def ask_for_task
    begin
      log "ask for task from server: #{@host}:#{@port}", :debug
      s = TCPSocket.open(@host, @port)

      response = ""
      while line = s.gets
          response += line
      end
      s.close

      log "recieved message: #{response}", :debug
      response
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on recieving new message from server: #{@host}:#{@port}", :error
      nil # this will force worker to be idle for current loop
    end
  end

  # it will return false if "none\n" is in message
  def message_is_task?(message)
    # Regex told that there should not be 'none\n' string to be a task.
    !!(/^((?!none\n)).*$/ =~ message)
  end

  def parse(message)
    begin
      hash = JSON::parse(message)

      task = Handlers::Task.new(hash)

      log "task parsed : #{task.to_s}", :debug
      task
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on task parsing. Parsed hash is: #{hash}", :error
    end
  end

  def register_actor_pools
    Celluloid::Actor[Handlers::GoogleAnalytics::ApiClient.name.tableize.singularize.to_sym] = Handlers::GoogleAnalytics::ApiClient.pool(size: 10)
    Celluloid::Actor[Handlers::GoogleAnalytics::ManagementApiClient.name.tableize.singularize.to_sym] = Handlers::GoogleAnalytics::ManagementApiClient.pool(size: 10)
    Celluloid::Actor[:result_saver] = Handlers::ResultSaver.pool(size: 5)
    Celluloid::Actor[:ender] = Handlers::Ender.pool(size: 5)
    Celluloid::Actor[:task_manager] = Handlers::TaskManager.pool(size: 5)
  end

  def find_actor_pool(task)
    symbol_name = task.handler.tableize.singularize.to_sym
    return Celluloid::Actor[symbol_name] if Celluloid::Actor[symbol_name].alive? unless Celluloid::Actor[symbol_name].nil?

    Celluloid::Actor[symbol_name] = Handlers.const_get(task.handler).pool
  end

  def process(task)
    log "processing started"

    # start doing the task with handler
    begin
      Retriable.retriable do
        find_actor_pool(task).run task
      end
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on task processing. Handler: #{task.handler}", :error
      task.failed(e)
      task = nil
      return # can't do something with this task after retries. So, it moves to next task
    end

    done_work
  end

  def done_work
    log "worker finished task"
    ActiveRecord::Base.connection.close

    # task.finished
    # task = nil
  end

  def wait_for_task
    log "worker is idle"

    # TODO: implement more complex logic
    sleep(TIME_TO_IDLE)
  end

  def log(message, level = :info)
    message = 'Worker: ' + message
    case level
    when :info
      @logger_to_file.info { message }
      STDERR.puts  'INFO: '  + message
    when :error
      @logger_to_file.error { message }
      STDERR.puts  'ERROR: '  + message
    else
      @logger_to_file.debug { message }
    end
  end
end
