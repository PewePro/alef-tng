class AddedPublicPrivateKeyToUser < ActiveRecord::Migration
  def change

    add_column :users, :private_key, :string, length: 64

  end
end
