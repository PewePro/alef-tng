class EvaluatorQuestion < LearningObject

  def get_solution
    values = user_to_lo_relations.where(type: 'UserSolvedLoRelation').pluck(:interaction).map { |n| n.to_i}

    return nil if values.empty?

    values.reduce(:+).to_f / values.size
  end

  def right_answer? (answer, solution)
    true
  end
end