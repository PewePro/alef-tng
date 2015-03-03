class CreateBasicSchema < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :login
      t.string   :aisid
      t.integer  :role
      t.string   :first_name
      t.string   :last_name

      t.string   :password
      t.string   :salt
      t.string   :authorization

      t.timestamps
    end

    create_table :setups do |t|
      t.string   :name
      t.datetime :first_week_at
      t.integer  :week_count

      t.timestamps
    end

    create_table :weeks do |t|
      t.belongs_to :setup
      t.integer :number
    end
    add_foreign_key :weeks, :setups

    create_table :setups_users do |t|
      t.belongs_to :setup, null: false
      t.belongs_to :user, null: false

      t.boolean :is_valid
      t.boolean :is_tracked

      t.timestamps
    end
    add_foreign_key :setups_users, :setups
    add_foreign_key :setups_users, :users

    create_table :learning_objects do |t|
      t.string :lo_id

      t.string :type

      # SingleChoiceQuestion, MultiChoiceQuestion, EvaluatorQuestion
      t.text :question_text

      t.timestamps
    end

    create_table :answers do |t|
      t.belongs_to :learning_object, null: false

      t.text :answer_text
      t.boolean :is_correct

      t.timestamps
    end
    add_foreign_key :answers, :learning_objects

    create_table :concepts do |t|
      t.belongs_to :setup, null: false
      t.string :name

      t.timestamps
    end
    add_foreign_key :concepts, :setups

    create_table :concepts_weeks do |t|
      t.belongs_to :week, null: false
      t.belongs_to :concept, null: false
    end
    add_foreign_key :concepts_weeks, :weeks
    add_foreign_key :concepts_weeks, :concepts

    create_table :user_to_lo_relations do |t|
      t.belongs_to :user, null: false
      t.belongs_to :learning_object, null: false
      t.belongs_to :setup, null: false

      t.string :type
      t.string :interaction

      t.timestamps
    end
    add_foreign_key :user_to_lo_relations, :users
    add_foreign_key :user_to_lo_relations, :learning_objects
    add_foreign_key :user_to_lo_relations, :setups

    create_table :concepts_learning_objects do |t|
      t.belongs_to :concept, null: false
      t.belongs_to :learning_object, null: false
    end
    add_foreign_key :concepts_learning_objects, :concepts
    add_foreign_key :concepts_learning_objects, :learning_objects

  end
end
