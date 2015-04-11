class AddReferenceIdToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :reference_id, :string
  end
end
