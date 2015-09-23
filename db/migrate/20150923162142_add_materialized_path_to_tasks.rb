class AddMaterializedPathToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :materialized_path, :integer, array: true, default: []
  end
end
