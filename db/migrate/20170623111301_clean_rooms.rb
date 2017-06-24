class CleanRooms < ActiveRecord::Migration
  def change
    remove_column :users, :involved_in_gamification, :boolean
    remove_column :users, :was_involved_in_gamification, :boolean
    remove_column :users, :proficiency, :float
    remove_column :user_to_lo_relations, :room_id, :integer
    remove_column :user_to_lo_relations, :activity_recommender_check, :boolean
    remove_column :user_to_lo_relations, :number_of_try, :integer
    remove_column :learning_objects, :irt_difficulty, :float
    remove_column :learning_objects, :irt_discrimination, :float

    drop_table :rooms_learning_objects do |t|
      t.integer :room_id
      t.integer :learning_object_id
    end

    drop_table :rooms do |t|
      t.integer :week_id
      t.integer :user_id
      t.string :name
      t.string :decsription
      t.string :state, default: 'do_not_use'
      t.integer :number_of_try
      t.float :score, default: 0.to_f
      t.float :score_limit, default: 0.to_f
    end

    drop_table :recommenders_options do |t|
      t.integer :recommendation_configuration_id, null: false
      t.integer :recommender_id, null: false
      t.integer :weight, null: false
    end

    drop_table :recommendation_linkers do |t|
      t.integer :user_id, null: false
      t.integer :week_id, null: false
      t.integer :recommendation_configuration_id, null: false
    end

    drop_table :recommendation_configurations do |t|
      t.string :name, null: false
      t.boolean :default, default: false
    end

    drop_table :recommenders do |t|
      t.string :name, null: false
    end

    drop_table :activity_recommender_records do |t|
      t.integer :learning_object_id, null: false
      t.integer :relation_learning_object_id, null: false
      t.string :relation_type, null: false
      t.integer :right_answers, null: false, default: 0
      t.integer :wrong_answers, null: false, default: 0
    end

  end
end
