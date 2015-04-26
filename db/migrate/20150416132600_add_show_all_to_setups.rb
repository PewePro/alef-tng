class AddShowAllToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :show_all, :boolean, default: false
  end
end
