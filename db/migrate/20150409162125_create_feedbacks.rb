class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :message, null: false
      t.integer :user_id
      t.text :url
      t.text :accept
      t.text :user_agent
      t.timestamps null: false
    end
  end
end
