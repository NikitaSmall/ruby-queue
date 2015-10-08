class AddFailedTasksCountersToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :failed_sub_task, :integer, default: 0
  end
end
