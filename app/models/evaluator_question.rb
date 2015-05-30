class EvaluatorQuestion < LearningObject

  def get_solution(user_id)
    rels = UserSolvedLoRelation.where('learning_object_id = (?) AND user_id <> (?)   ',self.id, user_id).order(created_at: :desc)
    values = Hash.new
    rels.each do |r|
      if values[r.user_id].nil?
        values[r.user_id] = r.interaction.to_i
      end
    end

    return nil if values.empty?

    values.values.reduce(:+).to_f / values.size
  end

  def right_answer?(answer, solution)
    true
  end
end