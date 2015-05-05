class AddLearningObjectIdToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :learning_object_id, :integer, default: nil
    add_foreign_key :feedbacks, :learning_objects
  end
end
