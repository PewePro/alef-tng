class AddCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.timestamps
    end
    remove_column :concepts, :setup_id
    add_column :setups, :course_id, :integer
    add_column :concepts, :pseudo, :boolean, default: true, null: false
    add_column :concepts, :course_id, :integer

    add_foreign_key :setups, :courses
    add_foreign_key :concepts, :courses

    course = Course.create!(name: 'Course One')
    Setup.update_all(course_id: course.id)
    Concept.update_all(course_id: course.id)

    change_column :setups, :course_id, :integer, null: false
    change_column :concepts, :course_id, :integer, null: false
  end
end
