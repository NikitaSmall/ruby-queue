require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/worker.rb')

describe Worker do
  describe '.new' do
    it 'should be created without task' do
      @worker = Worker.new('localhost', PORT)

      expect(@worker.task).to be(nil)
    end
  end

  describe '#parse' do
    before(:each) do
      @worker = Worker.new('localhost', PORT)
      create(:task, id: 3)
    end

    it 'returns task object from message' do
      message = File.read(File.join(File.dirname(__FILE__), 'support/broker_start_serve_last_task.json'))
      expect(@worker.send(:message_is_task?, message)).to be(true)

      task = @worker.send(:parse, message)

      expect(task).to be_a(Task)
      expect(task.id).to eq(Task.first.id)
    end
  end

  describe '#message_is_task?' do
    before(:each) do
      @worker = Worker.new('localhost', PORT)
    end

    it 'takes correct a json string from the server' do
      allow(@worker).to receive(:ask_for_task).and_return(File.read(File.join(File.dirname(__FILE__), 'support/broker_start_serve_last_task.json')))
      message = @worker.send(:ask_for_task)

      expect(message).to be_a(String)
      expect(@worker.send(:message_is_task?, message)).to be(true)
    end

    it 'checks nil/error messages correctly' do
      allow(@worker).to receive(:ask_for_task).and_return(nil)
      message = @worker.send(:ask_for_task)

      expect(@worker.send(:message_is_task?, message)).to be(false)
    end

    it 'checks "none\n" message correctly' do
      allow(@worker).to receive(:ask_for_task).and_return("none\n")
      message = @worker.send(:ask_for_task)

      expect(message).to be_a(String)
      expect(@worker.send(:message_is_task?, message)).to be(false)
    end
  end
end
