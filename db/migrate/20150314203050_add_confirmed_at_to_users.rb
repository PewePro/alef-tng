class AddConfirmedAtToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end
  end
  def self.down
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string
  end
end
