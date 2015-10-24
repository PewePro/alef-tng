class CreateRoomsLearningObjects < ActiveRecord::Migration
  def change
    create_table :rooms_learning_objects do |t|
      t.integer :room_id
      t.integer :learning_object_id
      t.string :difficulty
    end

    add_foreign_key :rooms_learning_objects, :learning_objects
    add_foreign_key :rooms_learning_objects, :rooms

  end
end
