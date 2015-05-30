class AddRightAnswersAndWrongAnswersToLearningObjects < ActiveRecord::Migration
  def change
    add_column :learning_objects, :right_answers, :integer, default: 0
    add_column :learning_objects, :wrong_answers, :integer, default: 0

     LearningObject.all.each do |lo|
       right = UserSolvedLoRelation.where(learning_object_id: lo.id).count
       wrong = UserFailedLoRelation.where(learning_object_id: lo.id).count + UserDidntKnowLoRelation.where(learning_object_id: lo.id).count
       lo.update(right_answers: right, wrong_answers: wrong)
     end
  end
end
