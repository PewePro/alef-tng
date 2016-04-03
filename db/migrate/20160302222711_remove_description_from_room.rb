class RemoveDescriptionFromRoom < ActiveRecord::Migration
  def change
    remove_column :rooms, :decsription, :string
  end
end
