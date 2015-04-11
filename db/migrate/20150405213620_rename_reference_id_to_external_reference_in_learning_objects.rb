class RenameReferenceIdToExternalReferenceInLearningObjects < ActiveRecord::Migration
  def change
    rename_column :learning_objects, :reference_id, :external_reference
  end
end
