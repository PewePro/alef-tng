class AddResolvedToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :resolved, :boolean, default: false
    add_index :feedbacks, [:learning_object_id, :resolved]
  end
end
