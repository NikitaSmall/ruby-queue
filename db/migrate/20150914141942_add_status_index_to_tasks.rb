class AddStatusIndexToTasks < ActiveRecord::Migration
  def change
    add_index(:tasks, :status, where: "status = 'new'")
  end
end
