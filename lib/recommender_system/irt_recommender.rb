module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    def get_probability
      los = self.learning_objects
      list = Hash.new
      los.each do |lo|
        irt_values = lo.irt_values.first
        if irt_values.nil?
          difficulty = 0.5
          discrimination = 0.5
        else
          difficulty = irt_values.difficulty.to_f
          discrimination = irt_values.discrimination.to_f
        end
        user = User.find(self.user_id)
        proficiency = user.proficiency.to_f
        probability = (Math::E**(discrimination*(proficiency-difficulty))) / (1 + Math::E**(discrimination*(proficiency-difficulty)))
        list[lo.id] = probability.to_f
      end
      list
    end

    def get_list
      list = get_probability
      list
    end
  end
end