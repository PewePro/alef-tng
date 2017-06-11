class EvaluatorQuestion < LearningObject

  def get_solution(user_id)
    answers_ids = self.answers.map{ |a| a.id }
    rels = UserSolutionLoRelation.eager_load(:user_to_lo_relation).
      where('user_solution_lo_relations.answer_id in (?) AND user_to_lo_relations.user_id <> (?) ', answers_ids, user_id)

    result = Hash.new
    answers_ids.each do |id|
      id_rels = rels.find_all {|r| r.answer_id == id}
      values = Hash.new

      id_rels.each do |r|
        if values[r.user_to_lo_relation.user_id].nil?
          values[r.user_to_lo_relation.user_id] = r.user_answer_evaluator.to_i
        end
      end
      result[id] = values.empty? ? nil : (values.values.reduce(:+).to_f / values.size).to_i
    end

    result
  end

  def right_answer?(answer, solution)
    true
  end
end