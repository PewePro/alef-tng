class AddImageToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :image, :binary
  end
end
