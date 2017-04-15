class AgregateEvaluatorQuestions < ActiveRecord::Migration
  def up
    evaluator_questions = EvaluatorQuestion.all
    agregated_question_texts = EvaluatorQuestion.group(:question_text).count()
    agregated_question_texts.delete_if { |k, v| v == 1 }
    agregated_ids = []

    agregated_question_texts.each do |text|
      agregated_questions = evaluator_questions.find_all {|q| q.question_text == text[0]}
      count = (agregated_questions.length / 10).to_i

      for i in 0..count
        questions = agregated_questions[i*10..(i+1)*10-1]
        q = questions[0]

        feedback_number = questions.map{ |q| q.feedback_number }.inject(0){|sum,x| sum + x }
        last_feedback_time = questions.map{ |q| q.last_feedback_time }.reject(&:blank?).max

        question_new = EvaluatorQuestion.create(:lo_id => q.lo_id, :type => q.type, :question_text => q.question_text,
                         :external_reference => q.external_reference, :image => q.image,
                         :course_id => q.course_id, :right_answers => q.right_answers,
                         :wrong_answers => q.wrong_answers, :difficulty => q.difficulty,
                         :importance => q.importance, :irt_difficulty => q.irt_difficulty,
                         :irt_discrimination => q.irt_discrimination, :deleted_at => nil,
                         :feedback_number => feedback_number, :last_feedback_time => last_feedback_time)

        ids = questions.map{ |q| q.id}
        agregated_ids += ids

        Answer.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
        Feedback.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
        UserToLoRelation.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
        RoomsLearningObject.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
        ActivityRecommenderRecord.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
        ConceptsLearningObject.where("learning_object_id IN (?)", ids).update_all(learning_object_id: question_new.id)
      end

    end

    LearningObject.where("id IN (?)", agregated_ids).delete_all
  end

  def down
  end
end