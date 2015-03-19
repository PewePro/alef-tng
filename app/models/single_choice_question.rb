class SingleChoiceQuestion < LearningObject

  def get_solution
    self.answers.find_by_is_correct(true).id
  end

end