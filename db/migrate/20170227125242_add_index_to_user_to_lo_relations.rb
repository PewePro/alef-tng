class AddIndexToUserToLoRelations < ActiveRecord::Migration
  def change
    add_index :user_to_lo_relations, :created_at
  end
end
