class RenameLastCommentTimeToLastFeedbackTimeInLearningObjects < ActiveRecord::Migration
  def change
    rename_column :learning_objects, :last_comment_time, :last_feedback_time
  end
end
