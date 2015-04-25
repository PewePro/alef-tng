class AddCourseToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :course_id, :integer
    LearningObject.update_all(course_id: Course.first.id)
  end
end
