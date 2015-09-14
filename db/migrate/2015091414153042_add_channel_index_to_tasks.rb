class AddChannelIndexToTasks < ActiveRecord::Migration
  def change
    add_index(:tasks, :channel)
  end
end
