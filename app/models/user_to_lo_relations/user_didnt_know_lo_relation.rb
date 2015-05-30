class UserDidntKnowLoRelation < UserToLoRelation

  after_create :mark_wrong_answer

  protected
  def mark_wrong_answer
    LearningObject.where(id: self.learning_object_id).update_all('wrong_answers = wrong_answers + 1')
  end

end