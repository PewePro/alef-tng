class AddDifficultyToLearningObject < ActiveRecord::Migration
  def change
    add_column :learning_objects, :difficulty, :string, :default => LearningObject::DIFFICULTY[:UNKNOWN]
  end
end
