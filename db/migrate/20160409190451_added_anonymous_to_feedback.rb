class AddedAnonymousToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :anonymous_teacher, :boolean, null: false, default: false
  end
end
