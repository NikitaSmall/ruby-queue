require 'json'
require 'yaml'
require 'socket'
require 'thread'

require File.join(File.dirname(__FILE__), 'model/task.rb')

class Broker
  include Singleton
  attr_accessor :tasks, :channels

  def start_serve(port)
    semaphore = Mutex.new
    get_channel_configs

    get_new_tasks
    server = TCPServer.new port
    loop do
      begin
        Thread.start(server.accept_nonblock) do |client|
          semaphore.synchronize do
            get_new_tasks if @tasks.empty?

            if @tasks.empty?
              say_none(client)
            else
              give_task_to_client(client)
            end

            client.close
          end
        end
      rescue IO::WaitReadable, Errno::EINTR
        IO.select([server])
        retry
      end

    end
  end

  private
  def get_new_tasks
    # working with default and mistuped channels
    @tasks = Task.where(status: 'new').where('channel NOT IN (?) OR channel IS NULL', @channels.keys).limit(3).to_a
    # working with each channel from preferences
    @channels.each_pair do |channel_name, channel|
      @tasks += Task.where(status: 'new', channel: channel_name).limit(channel['rps']).to_a
    end
  end

  def give_task
    task = @tasks.pop
    task.doing

    task.to_json
  end

  def give_task_to_client(client)
    client.puts give_task
  end

  def say_none(client)
    client.puts "none"
  end

  def get_channel_configs
    @channels = YAML::load(File.open(File.join(File.dirname(__FILE__), '../config/channels.yml')))
  end
end
