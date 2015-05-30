class AddForeignKeyToFeedback < ActiveRecord::Migration
  def change
    add_foreign_key :feedbacks, :users
  end
end
