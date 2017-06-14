class CreateQuizSchema < ActiveRecord::Migration

  def change
    create_table :quizzes do |t|
      t.integer :week_id, null: false
      t.integer :rank
      t.boolean :repeating, default: false
      t.string :name, null: false
    end

    create_table :quizess_learning_objects do |t|
      t.integer :quiz_id, null: false
      t.integer :learning_object_id, null: false
      t.integer :rank
    end

    add_foreign_key :quizzes, :weeks
    add_foreign_key :quizess_learning_objects, :quizzes
    add_foreign_key :quizess_learning_objects, :learning_objects

  end
end
