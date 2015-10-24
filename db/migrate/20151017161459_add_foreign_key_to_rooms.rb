class AddForeignKeyToRooms < ActiveRecord::Migration
  def change
    add_foreign_key :rooms, :weeks
  end
end