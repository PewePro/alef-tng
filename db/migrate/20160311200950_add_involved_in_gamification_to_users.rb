class AddInvolvedInGamificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :involved_in_gamification, :boolean, null: false, default: true
  end
end
