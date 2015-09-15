class CreateComplexPartialIndexOnStatusAndChannel < ActiveRecord::Migration
  def change
    remove_index :tasks, :channel
    remove_index :tasks, :status

    add_index :tasks, [:status, :channel], where: "status = 'new'"
  end
end
