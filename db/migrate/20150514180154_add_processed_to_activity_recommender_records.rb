class AddProcessedToActivityRecommenderRecords < ActiveRecord::Migration
  def change
    add_column :activity_recommender_records, :processed, :boolean, default: false
  end
end
