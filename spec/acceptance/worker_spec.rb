require File.join(File.dirname(__FILE__), '../spec_helper.rb')
require File.join(File.dirname(__FILE__), '../../lib/worker.rb')
require 'socket'

def create_task(options)
  thr = Thread.new do
    create(:task, options)
  end
  thr.join
  thr.kill
end

describe Worker do
  describe '#ask_for_task' do
    before(:each) do
      DatabaseCleaner.strategy = :truncation
      @worker = Worker.new('localhost', PORT)
    end

    it 'takes correct message from server' do
      message = @worker.send(:ask_for_task)

      expect(message).to be_a(String)
      expect(message).not_to eq("")

      expect(message).to eq("none\n")
    end

    it 'represents correct serialized task' do
      create_task(handler: 'ResultSaver')

      message = @worker.send(:ask_for_task)
      task = @worker.send(:parse, message)

      expect(task.id).to eq(Task.last.id)
    end

    it 'fires an error when connection refuse' do
      @worker.port += 1

      message = @worker.send(:ask_for_task)
      expect(message).to be(nil)
    end
  end

  describe '#process' do
    before(:each) do
      DatabaseCleaner.strategy = :truncation
      @worker = Worker.new('localhost', PORT)
    end

    it 'correctly process for a correct task' do
      create_task(JSON::parse(File.read(File.join(File.dirname(__FILE__), '../support/broker_start_serve_last_task.json'))))
      message = @worker.send(:ask_for_task)

      task = @worker.send(:parse, message)
      @worker.send(:process, task)

      expect(Task.last.status).to eq('done')
    end

    it 'fires error on process for an invalid task' do
      create_task(handler: 'ResultSaver', argument: {"a" => 20, "b" => 0}.to_json)
      message = @worker.send(:ask_for_task)

      task = @worker.send(:parse, message)
      @worker.send(:process, task)

      expect(Task.last.status).to eq('failed')
    end
  end
end
