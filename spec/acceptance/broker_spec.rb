require File.join(File.dirname(__FILE__), '../spec_helper.rb')
require File.join(File.dirname(__FILE__), '../../lib/broker.rb')
require 'socket'

def take_response_from_server(port)
  s = TCPSocket.open('localhost', port)

  response = ""
  while line = s.gets
      response += line
  end
  s.close
  response
end

def create_task(options)
  thr = Thread.new do
    create(:task, options)
  end
  thr.join
  thr.kill
end

describe Broker do
  before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  describe '#start_serve' do
    it 'shows none when there are no new tasks' do
      create_task(handler: 'devider', status: 'done')

      message = take_response_from_server(PORT)
      expect(message).to eq("none\n")
    end

    it 'shows serialized new task when it appears' do
      create_task(handler: 'devider', channel: 'some strange chanel')

      message = take_response_from_server(PORT)
      expect(message).not_to eq("none\n")
      expect(JSON::parse(message)['id']).to eq(Task.last.id)
    end

    it 'changes task status when send it to client' do
      create_task(handler: 'devider')

      message = take_response_from_server(PORT)

      expect(message).not_to eq('none\n')
      expect(Task.last.status).to eq('doing')
    end

    it 'shows different tasks from queue that cleared' do
      create_task(handler: 'summ')
      create_task(handler: 'devider')

      message1 = take_response_from_server(PORT)
      message2 = take_response_from_server(PORT)
      message3 = take_response_from_server(PORT)

      expect(message1).not_to eq('none\n')
      expect(message2).not_to eq('none\n')

      expect(message1).not_to eq(message2)
      expect(message3).to eq("none\n")
    end
  end
end
