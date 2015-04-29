class AddLearningObjectIdToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :learning_object_id, :integer, default: nil
  end
end
