class MultiChoiceQuestion < LearningObject

  def get_solution(user_id)
    self.answers.where(is_correct: true).ids
  end

  def right_answer?(answer, solution)

    if answer == nil
      return solution.empty?
    end

    answer = answer.values.map { |n| n.to_i }
    solution == answer

  end
end