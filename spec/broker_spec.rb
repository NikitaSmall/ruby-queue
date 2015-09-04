require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/broker.rb')
require 'socket'


describe Broker do
  describe '#give_task' do
    before(:each) do
      create(:task)
      create(:task, argument: '{"a":20,"b":22}')
      @task = create(:task, handler: 'devider', argument: '{"a":20,"b":32}')
    end

    it 'shows a correct new task' do
      broker = Broker.instance

      broker.send(:get_new_tasks)
      new_task = broker.send(:give_task)

      expect(new_task).not_to eq("none")
      expect(new_task).not_to eq("none\n")
      expect(new_task).not_to eq("")
      expect(new_task).not_to eq(nil)
    end

    it 'always shows last added task' do
      broker = Broker.instance

      broker.send(:get_new_tasks)
      new_task = JSON::parse(broker.send(:give_task))

      expect(@task).to eq (Task.find(new_task["id"]))
    end

    it 'counts tasks correctly' do
      broker = Broker.instance
      broker.send(:get_new_tasks)

      expect(broker.tasks.count).to eq(3)
      broker.send(:give_task)

      expect(broker.tasks.count).to eq(2)
    end

  end
end
