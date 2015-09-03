require 'json'
require 'socket'
require File.join(File.dirname(__FILE__), 'model/task.rb')

class Broker
  include Singleton
  attr_accessor :tasks

  def start_serve(port)
    get_new_tasks
    server = TCPServer.open port

    while client = server.accept      
      get_new_tasks if @tasks.empty?

      if @tasks.empty?
        say_none(client)
      else
        give_task_to_client(client)
      end

      client.close
    end
  end

  private

  def get_new_tasks
    @tasks = Task.where(status: 'new').to_a
  end

  def give_task_to_client(client)
    task = @tasks.pop
    task.doing
    client.puts task.to_json
  end

  def say_none(client)
    client.puts "none"
  end
end
