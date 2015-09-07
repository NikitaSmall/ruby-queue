require 'json'
require 'socket'

require 'retriable'

require File.join(File.dirname(__FILE__), 'model/task.rb')

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
        # TODO: implement retriable on error here
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
      log "ask for task from server: #{@host}:#{@port}"
      s = TCPSocket.open(@host, @port)

      response = ""
      while line = s.gets
          response += line
      end
      s.close

      log "recieved message: #{response}"
      response
    rescue => e
      log "#{e.class}: '#{e.message}' - Error on recieving new message from server: #{@host}:#{@port}", :error
      nil # this will force worker to be idle for current loop
    end
  end

  def message_is_task?(message)
    # it will return nil if "none\n" is in response. So we will try to parse it
    !!(/^((?!none\n)).*$/ =~ message) # message doesn't contain none with new_line symbols. So, it should be a message
  end

  def parse(message)
    hash = JSON::parse(message)
    @task = Task.new(hash)

    log "task parsed : #{@task.to_s}"
  end

  def processing
    raise 'Not a task found' unless @task.is_a? Task
    log "processing started"
    @task.doing

    # TODO: implement processing
    sleep(5)

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
    case level
    when :info
      @logger_to_file.info { message }
      @logger_to_console.info { message }
    when :error
      @logger_to_file.error { message }
      @logger_to_console.error { message }
    else
      @logger_to_file.debug { message }
      @logger_to_console.debug { message }
    end
  end
end
