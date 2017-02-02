class AddCommentNumberToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :comment_number, :integer, default: 0
  end
end
