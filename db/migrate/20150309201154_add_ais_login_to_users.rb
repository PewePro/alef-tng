class AddAisLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :aislogin, :string
  end
end
