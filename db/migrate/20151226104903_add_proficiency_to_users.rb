class AddProficiencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :proficiency, :float, default: 0.5
  end
end
