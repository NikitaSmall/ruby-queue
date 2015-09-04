require 'json'
require 'socket'

require File.join(File.dirname(__FILE__), 'model/task.rb')

class Worker
  attr_accessor :task, :host, :port

  def initialize(host, port)
    @host = host
    @port = port

    @logger = Logger.new('logs/logfile.log')

    listen_for_task
  end

  private
  def listen_for_task
    @logger.info { "worker started" }
    loop do
      # TODO: implement task retry or new query to server logic
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

  # TODO: implement checking of host availity
  def ask_for_task
    @logger.info { "ask for task from server: #{@host}:#{@port}" }
    s = TCPSocket.open(@host, @port)

    response = ""
    while line = s.gets
        response += line
    end
    s.close

    @logger.info { "recieved message: #{response}" }
    response
  end

  def message_is_task?(message)
    /^((?!none\n)).*$/ =~ message # message doen't contain none with new_line symbols. So, it should be a message
  end

  def parse(message)
    hash = JSON::parse(message)
    @task = Task.find(hash["id"])

    @logger.info { "task parsed : #{@task.to_s}" }
  end

  def processing
    raise 'Not a task found' unless @task.is_a? Task
    @logger.info { "processing started" }

    # TODO: implement processing
    sleep(5)

    done_work
  end

  def done_work
    @logger.info { "task is complete" }

    @task.finished
    @task = nil
  end

  def wait_for_task
    @logger.info { "worker is idle" }

    # TODO: implement more complex logic
    sleep(10)
  end
end
