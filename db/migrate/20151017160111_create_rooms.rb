class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :week_id
      t.integer :user_id
      t.string :name
      t.string :decsription
      t.string :state, default: 'do_not_use'
      t.integer :number_of_try
      t.float :score, default: 0.to_f
      t.float :score_limit, default: 0.to_f
    end

    add_foreign_key :rooms, :weeks
    add_foreign_key :rooms, :users

  end
end