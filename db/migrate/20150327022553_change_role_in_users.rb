class ChangeRoleInUsers < ActiveRecord::Migration
  def change
    add_column :users, :role2, :string, null: false, default: :student

    User.all.each do |u|
      u.role2 = ['student', 'teacher', 'administrator'][u.role || 0]
      u.save!
    end

    remove_column :users, :role
    rename_column :users, :role2, :role
  end
end
