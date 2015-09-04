require 'json'
require 'socket'
require 'thread'

require File.join(File.dirname(__FILE__), 'model/task.rb')

class Broker
  include Singleton
  attr_accessor :tasks

  def start_serve(port)
    semaphore = Mutex.new

    get_new_tasks
    server = TCPServer.new port

    loop do
      Thread.start(server.accept) do |client|
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
    end
  end

  private
  def get_new_tasks
    @tasks = Task.where(status: 'new').to_a
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
end
