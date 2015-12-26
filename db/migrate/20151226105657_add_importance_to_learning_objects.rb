class AddImportanceToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :importance, :string, default: 'UNKNOWN'
  end
end
