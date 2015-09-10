require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/model/task.rb')

describe Task do
  describe '#channel_config' do
    it 'shows correct config for exists channel' do
      task = create(:task, channel: 'channel_one')

      expect(task.channel_config['rps']).to eq(10)
    end

    it 'shows false on invalid or non-exist channel' do
      task = create(:task, channel: 'I am nobody!')

      expect(task.channel_config).to eq(false)
    end
  end
end
