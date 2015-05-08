class CreateRecommendationsSchema < ActiveRecord::Migration
  def change
    create_table :recommenders do |t|
      t.string :name, null: false
    end

    create_table :recommendation_configurations do |t|
      t.string :name, null: false
      t.boolean :default, default: false
    end

    create_table :recommendation_linkers do |t|
      t.integer :user_id, null: false
      t.integer :week_id, null: false
      t.integer :recommendation_configuration_id, null: false
    end

    create_table :recommenders_options do |t|
      t.integer :recommendation_configuration_id, null: false
      t.integer :recommender_id, null: false
      t.integer :weight, null: false
    end

    add_foreign_key :recommendation_linkers, :weeks
    add_foreign_key :recommendation_linkers, :users
    add_foreign_key :recommendation_linkers, :recommendation_configurations

    add_foreign_key :recommenders_options, :recommendation_configurations
    add_foreign_key :recommenders_options, :recommenders


  end
end
