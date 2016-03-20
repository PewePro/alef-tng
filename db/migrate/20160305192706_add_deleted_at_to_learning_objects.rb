class AddDeletedAtToLearningObjects < ActiveRecord::Migration
  def change

    add_column :learning_objects, :deleted_at, :datetime
    add_index :learning_objects, :deleted_at

  end
end
