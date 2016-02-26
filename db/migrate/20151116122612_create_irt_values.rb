class CreateIrtValues < ActiveRecord::Migration
  def change
    create_table :irt_values do |t|
      t.float :difficulty
      t.float :discrimination
      t.integer :learning_object_id
    end

    add_foreign_key :irt_values, :learning_objects
  end
end