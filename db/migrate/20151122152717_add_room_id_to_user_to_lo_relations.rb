class AddRoomIdToUserToLoRelations < ActiveRecord::Migration
  def change
    add_column :user_to_lo_relations, :room_id, :integer
    add_column :user_to_lo_relations, :number_of_try, :integer
  end


end
