class AddIrtToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :irt_difficulty, :float, null: true
    add_column :learning_objects, :irt_discrimination, :float, null: true
  end
end
