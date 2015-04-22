class AddEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :ais_email, :string
  end
end
