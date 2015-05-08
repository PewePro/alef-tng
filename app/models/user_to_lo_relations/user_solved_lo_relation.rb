class UserSolvedLoRelation < UserCompletedLoRelation

  after_create :mark_right_answer

  protected
    def mark_right_answer
      LearningObject.where(id: self.learning_object_id).update_all('right_answers = right_answers + 1')
    end

end