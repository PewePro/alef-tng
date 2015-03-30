class FixDeviseUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      ## REMOVE alef v1 fields
      t.remove :password
      t.remove :salt
      t.remove :authorization
      t.remove :aislogin

      ## SKIP LDAP authenticatable
      # t.string :login, :null => false, :default => '', :unique => true

      ## SKIP Rememberable
      # t.datetime :remember_created_at

      ## SKIP Trackable
      # t.integer  :sign_in_count, :default => 0
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip
      # t.timestamps

      ## ------------------------------------------------
      ## REMOVE database authenticatable
      t.remove :email
      t.remove :encrypted_password

      ## REMOVE recoverable
      t.remove  :reset_password_token
      t.remove  :reset_password_sent_at

      ## SKIP Rememberable
      # t.datetime :remember_created_at

      ## SKIP Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## REMOVE Confirmable
      t.remove   :confirmation_token
      t.remove   :confirmed_at
      t.remove   :confirmation_sent_at
      t.remove   :unconfirmed_email # Only if using reconfirmable

      ## REMOVE Lockable
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
    end

    add_index :users, :login,                unique: true
  end

  def self.down
    # sorry, you just can't return to the previous mess
    raise ActiveRecord::IrreversibleMigration
  end
end
