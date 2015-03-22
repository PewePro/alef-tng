class SingleChoiceQuestion < LearningObject

  def get_solution
    self.answers.where(is_correct: true).ids
  end

  def right_answer? (answer, solution)
    answer.to_i == solution[0]
  end
end