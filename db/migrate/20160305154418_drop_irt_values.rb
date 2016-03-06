class DropIrtValues < ActiveRecord::Migration
  def change
    drop_table :irt_values do |t|
      t.float :difficulty, null: false
      t.float :discrimination, null: false
      t.integer :learning_object_id, null: false
    end
  end
end
