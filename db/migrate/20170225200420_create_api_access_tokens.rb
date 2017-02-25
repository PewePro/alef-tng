class CreateApiAccessTokens < ActiveRecord::Migration
  def change

    create_table :api_access_tokens do |t|
      t.integer :user_id
      t.string :token, length: 100
      t.timestamp :expires_at
      t.timestamps
    end

    add_foreign_key :api_access_tokens, :users

    add_index :users, [:login, :private_key]
    add_index :users, :private_key
    add_index :api_access_tokens, :token

  end
end
