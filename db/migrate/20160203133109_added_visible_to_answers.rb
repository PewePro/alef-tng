class AddedVisibleToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :visible, :boolean, null: false, default: true
  end
end
