class AddDeletedAtToLearningObjects < ActiveRecord::Migration
  def change

    unless column_exists? :learning_objects, :deleted_at
      add_column :learning_objects, :deleted_at, :datetime
      add_index :learning_objects, :deleted_at
    end

  end
end
