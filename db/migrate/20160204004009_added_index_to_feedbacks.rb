class AddedIndexToFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, [:learning_object_id, :accepted]
  end
end
