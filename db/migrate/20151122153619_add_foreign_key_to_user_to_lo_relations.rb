class AddForeignKeyToUserToLoRelations < ActiveRecord::Migration
  def change
    add_foreign_key :user_to_lo_relations, :rooms
  end
end
