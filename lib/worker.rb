require 'json'
require 'socket'

require 'retriable'

require File.join(File.dirname(__FILE__), 'model/task.rb')

require File.join(File.dirname(__FILE__), 'handlers/summ.rb')
require File.join(File.dirname(__FILE__), 'handlers/divider.rb')

class Worker
  attr_accessor :task, :host, :port
  TIME_TO_IDLE = 10 # seconds wait for a new task or server restoring (if an error was occured)

  def initialize(host, port)
    @task = nil
    @host = host
    @port = port

    @logger_to_file = Logger.new('logs/logfile.log')
    @logger_to_console = Logger.new(STDERR)
  end

  def listen_for_task
    log "worker started"
    loop do
      message = ask_for_task

      if message_is_task? message
        parse message
        processing
      else
        wait_for_task
      end
    end
  end

  private
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
      @task = Task.new(hash)

      log "task parsed : #{@task.to_s}", :debug
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on task parsing. Message is: #{message}", :error
    end
  end

  def processing
    log "processing started"
    return unless @task.is_a? Task
    # start doing the task with handler
    begin
      Retriable.retriable do
        options = JSON::load(@task.argument) # expect that arguments stored as json hash
        handler = @task.handler.split("_").collect(&:capitalize).join
        Handlers.const_get(handler).new(options).run
      end
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on task processing. Handler: #{@task.handler}; Arguments: #{@task.argument}", :error
      @task.failed(e)
      @task = nil
      return # can't do something with this task after retries. So, it moves to next task
    end

    done_work
  end

  def done_work
    log "task is complete"

    @task.finished
    @task = nil
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
      @logger_to_console.info { message }
    when :error
      @logger_to_file.error { message }
      @logger_to_console.error { message }
    else
      @logger_to_file.debug { message }
    end
  end
end
