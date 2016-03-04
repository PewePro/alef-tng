module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    def get_probability
      los = Week.find(@@week_id).free_los_with_irt(@@type_question,@@user_id)
      list = Hash.new
      user = User.find(self.user_id)
      proficiency = user.proficiency
      los.each do |lo|
        irt_values = lo.irt_values.first
        if irt_values.nil?
          difficulty = 0.5
          discrimination = 0.5
        else
          difficulty = irt_values.difficulty
          discrimination = irt_values.discrimination
        end
        probability = (Math::E**(discrimination*(proficiency-difficulty))) / (1 + Math::E**(discrimination*(proficiency-difficulty)))
        list[lo.id] = probability
      end
      list
    end

    def get_list
      list = get_probability
      list
    end
  end
end