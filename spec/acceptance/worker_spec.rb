require File.join(File.dirname(__FILE__), '../spec_helper.rb')
require File.join(File.dirname(__FILE__), '../../lib/worker.rb')
require 'socket'

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
      thr = Thread.new do
        create(:task, handler: 'devider')
      end
      thr.join
      thr.kill
      message = @worker.send(:ask_for_task)
      @worker.send(:parse, message)

      expect(@worker.task.id).to eq(Task.last.id)
    end
  end
end
