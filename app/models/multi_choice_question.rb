class MultiChoiceQuestion < LearningObject

  def get_solution
    self.answers.where(is_correct: true).ids
  end

end