module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    def get_probability
      # Toto nefunguje dobre s diakritikou
      # Cely tento recommender je vsak len na testovanie, takze nemusi fungovat na 100%
      los = self.learning_objects

      list = Hash.new

      los.each do |lo|
        irt_values = lo.irt_values.where("user_id = ?", self.user_id)
        difficulty = irt_values.difficulty.to_f
        discrimination = irt_values.discrimination.to_f
        user = User.find(self.user_id)
        proficiency = user.proficiency.to_f

        probability = (E**(discrimination*(proficiency-difficulty))) / (1 + E**(discrimination*(proficiency-difficulty)))

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