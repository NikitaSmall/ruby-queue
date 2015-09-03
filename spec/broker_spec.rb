require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/broker.rb')
require 'socket'
require 'thread'

describe Broker do
  describe '#start_serve' do
    before(:each) do
      Task.create(handler: 'summ', argument: '{"a":10,"b":12}')
      Task.create(handler: 'summ', argument: '{"a":20,"b":22}')
      Task.create(handler: 'devider', argument: '{"a":20,"b":32}')

      @thr = Thread.new do
        @broker = Broker.instance
        @broker.start_serve(4000)
      end
    end

    after(:each) do
      Thread.kill(@thr)
    end

    it 'show a correct new task' do
      s = TCPSocket.open('localhost', 4000)

      response = ""
      while line = s.gets
          response += line
      end
      s.close
      p response

      expect(response).not_to eq("none")
      expect(response).not_to eq("none\n")
      expect(response).not_to eq("")
      expect(response).not_to eq(nil)
    end

  end
end
