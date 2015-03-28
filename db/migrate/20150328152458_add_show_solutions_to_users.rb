class AddShowSolutionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_solutions, :boolean, default: false
  end
end
