class RenameCommentNumberToFeedbackNumberInLearningObjects < ActiveRecord::Migration
  def change
    rename_column :learning_objects, :comment_number, :feedback_number
  end
end
