class AddLastCommentTimeToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :last_comment_time, :datetime
  end
end
