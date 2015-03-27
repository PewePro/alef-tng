class AddTypeToUsers < ActiveRecord::Migration
  def self.up
    # add STI column, temporarily specify default value
    add_column :users, :type, :string, null: false, default: ''

    # guess type based on password presence
    User.all.each do |u|
      u.type = u.encrypted_password.empty? ? 'LdapUser' : 'LocalUser'
      u.save!
    end

    # remove default value
    change_column :users, :type, :string, null: false
  end

  def self.down
    remove_column :users, :type
  end
end
