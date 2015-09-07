require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/worker.rb')

describe Worker do
  describe '#ask_for_task' do
    before(:each) do
      @worker = Worker.new('localhost', 5000)
    end

    it 'takes correct a json string from the server' do
      tcp = double('TCP server', null_object: true)
      TCPSocket.should_receive(:open).with('localhost', 5000)
      tcp.should_receive(:gets).and_return(File.read(File.join(File.dirname(__FILE__), 'support/broker_start_serve_last_task.json')))

      @worker.send(:ask_for_task)
    end
  end
end
