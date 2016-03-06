module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    # Metoda vytvori list learning objektov s priradenymi hodnotami na zaklade pravdepodobnosti spravnej odpovede urcenej cez Item Response Theory
    def get_probability
      los = self.learning_objects
      list = Hash.new
      user = User.find(self.user_id)
      proficiency = user.proficiency
      los.each do |lo|
        if lo.irt_difficulty.nil?
          difficulty = 0.5
        else
          difficulty = lo.irt_difficulty
        end
        if lo.irt_discrimination.nil?
          discrimination = 0.5
        else
          discrimination = lo.irt_discrimination
        end
        # Vypocet pravdepodobnosti na zaklade 2P IRT
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