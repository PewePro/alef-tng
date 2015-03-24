class RenameQuestionTypeToTypeInLearningObjects < ActiveRecord::Migration
  def change
    rename_column :learning_objects, :question_type, :type
  end
end
