module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    # Metoda vytvori list learning objektov s priradenymi hodnotami na zaklade pravdepodobnosti spravnej odpovede urcenej cez Item Response Theory
    def get_list
      los = self.learning_objects
      list = Hash.new
      user = User.find(self.user_id)
      proficiency = user.proficiency
      los.each do |lo|
        difficulty = lo.irt_difficulty || 0.5
        discrimination = lo.irt_discrimination || 0.5
        # Vypocet pravdepodobnosti na zaklade 2P IRT
        probability = (Math::E**(discrimination*(proficiency-difficulty))) / (1 + Math::E**(discrimination*(proficiency-difficulty)))
        list[lo.id] = probability
      end
      list
    end

    # Opakuje sa o stvrtej rano, vid. config/schedule.rb
    def self.update_table
      p "dnuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
      User.find(1).update!(proficiency: 500)
    end
  end
end