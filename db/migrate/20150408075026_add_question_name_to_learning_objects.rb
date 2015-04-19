class AddQuestionNameToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :question_name, :string
  end
end
