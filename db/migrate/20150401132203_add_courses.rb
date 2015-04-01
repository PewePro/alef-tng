class AddCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.timestamps
    end
    remove_column :concepts, :setup_id
    add_column :setups, :course_id, :integer
    add_column :concepts, :pseudo, :boolean
    add_column :concepts, :course_id, :integer
  end
end
