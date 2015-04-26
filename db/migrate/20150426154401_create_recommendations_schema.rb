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
  end
end
