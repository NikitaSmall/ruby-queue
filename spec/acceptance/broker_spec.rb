
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

describe Broker do
  before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  describe '#start_serve' do
    it 'shows none when there are no new tasks' do
      message = take_response_from_server(PORT)
      expect(message).to eq("none\n")
    end

    it 'shows serialized new task when it appears' do
      thr = Thread.new do
        create(:task, handler: 'devider')
      end
      thr.join
      thr.kill

      message = take_response_from_server(PORT)
      expect(message).not_to eq("none\n")
      expect(JSON::parse(message)['id']).to eq(Task.last.id)
    end
  end
end
