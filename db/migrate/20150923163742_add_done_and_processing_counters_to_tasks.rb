class AddDoneAndProcessingCountersToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :processing_sub_task, :integer, default: 0
    add_column :tasks, :done_sub_task, :integer, default: 0
  end
end
