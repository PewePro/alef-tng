class AddStatusToFeedback < ActiveRecord::Migration
  def change
    remove_column :feedbacks, :resolved
    add_column :feedbacks, :accepted, :boolean, null: true, default: nil
    add_column :feedbacks, :visible, :boolean, null: false, default: true
  end
end
