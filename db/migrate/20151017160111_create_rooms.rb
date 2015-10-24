class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :week_id
      t.string :name
      t.string :difficulty, :default => LearningObject::DIFFICULTY[:UNKNOWN]
    end
  end
end