require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/broker.rb')
require 'socket'

describe Broker do
  before(:each) do
    @br = Broker.instance
  end

  describe '#get_new_tasks' do
    it 'serves tasks in different position each time' do
      create(:task, argument: '{"a":12,"b":22}', channel: 'channel_two')
      create(:task, argument: '{"a":22,"b":22}', channel: 'channel_two')
      create(:task, argument: '{"a":32,"b":22}', channel: 'channel_two')
      create(:task, argument: '{"a":12,"b":22}', channel: 'bad_channel')

      @br.send(:get_new_tasks)
      tasks_sequence_one = @br.tasks

      @br.send(:get_new_tasks)
      tasks_sequence_two = @br.tasks
      expect(tasks_sequence_one).not_to eq(tasks_sequence_two)
    end

    it 'takes tasks according to channels config: doesn\'t take at all' do
      create(:task, argument: '{"a":12,"b":22}', channel: 'closed_channel')
      create(:task, argument: '{"a":22,"b":22}', channel: 'closed_channel')

      @br.send(:get_new_tasks)

      expect(@br.tasks.count).to eq(0)
    end

    it 'takes tasks according to channels config: takes only few of them' do
      create(:task, argument: '{"a":12,"b":22}', channel: 'bad_channel')
      create(:task, argument: '{"a":22,"b":22}', channel: 'bad_channel')
      create(:task, argument: '{"a":32,"b":22}', channel: 'bad_channel')

      @br.send(:get_new_tasks)

      expect(@br.tasks.count).to eq(1)
      expect(@br.tasks[0]).to eq(Task.first)
    end

    it 'takes tasks according to channels config: takes only few of them' do
      create(:task, argument: '{"a":12,"b":22}', channel: 'channel_two')
      create(:task, argument: '{"a":22,"b":22}', channel: 'channel_two')
      create(:task, argument: '{"a":32,"b":22}', channel: 'channel_two')

      @br.send(:get_new_tasks)

      expect(@br.tasks.count).to eq(3)
    end
  end

  describe '#give_task' do
    before(:each) do
      create(:task, argument: '{"a":12,"b":22}')
      @task = create(:task, handler: 'devider', argument: '{"a":20,"b":32}')
      create(:task, argument: '{"a":20,"b":22}')

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

    it 'counts tasks correctly' do
      broker = Broker.instance
      broker.send(:get_new_tasks)

      expect(broker.tasks.count).to eq(3)
      broker.send(:give_task)

      expect(broker.tasks.count).to eq(2)
    end

  end
end
