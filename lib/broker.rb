require 'json'
require 'yaml'
require 'socket'
require 'thread'

require File.join(File.dirname(__FILE__), 'model/task.rb')

class Broker
  include Singleton
  attr_reader :tasks, :serving

  DEFAULT_RPS_LIMIT = 3

  def initialize
    @serving = true
  end

  def start_serve(port)
    get_new_tasks

    server = TCPServer.new port
    while @serving do
      ["INT", "TERM"].each { |signal| trap(signal) { stop_serving } }
      begin
        # Thread.start(server.accept_nonblock) do |client|
        Thread.start(server.accept) do |client|
          semaphore.synchronize do
            get_new_tasks if @tasks.empty?
          end

          if @tasks.empty?
            say_none(client)
          else
            semaphore.synchronize do
              give_task_to_client(client)
            end
          end

          client.close
        end
      rescue IO::WaitReadable, Errno::EINTR
        IO.select([server])
        retry
      end

    end
  end

  private
  def stop_serving
    @serving = false
  end

  def get_new_tasks
    # working with default and mistyped channels
    sql = '(' + Task.where(status: 'new').where('channel NOT IN (?) OR channel IS NULL', channels.keys).limit(default_rps_limit).to_sql + ')'
    # working with each channel from preferences
    channels.each_pair do |channel_name, channel|
      sql += ' UNION '
      sql += '(' + Task.where(status: 'new', channel: channel_name).limit(channel['rps']).to_sql + ')'
    end
    @tasks = Task.find_by_sql(sql).shuffle
  end

  def semaphore
    @semaphore ||= Mutex.new
  end

  def give_task
    task = @tasks.pop
    task.doing

    task.to_json
  end

  def channel_names
    channels.keys
  end

  def default_rps_limit
    DEFAULT_RPS_LIMIT
  end

  def give_task_to_client(client)
    client.puts give_task
  end

  def say_none(client)
    client.puts "none"
  end

  def channels
    @channels ||= YAML::load(File.open(File.join(File.dirname(__FILE__), '../config/channels.yml')))
  end
end
