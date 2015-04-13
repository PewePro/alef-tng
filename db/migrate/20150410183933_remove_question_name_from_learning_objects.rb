class RemoveQuestionNameFromLearningObjects < ActiveRecord::Migration
  def change
    remove_column :learning_objects, :question_name, :string
  end
end
