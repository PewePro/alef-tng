module RecommenderSystem
  class ActivityRecommender < RecommenderSystem::Recommender

    def get_list

      relations = self.get_model

      list = Hash.new

      self.learning_objects.each do |lo|
        list[lo.id] = 0
        relations.each do |r|
          list[lo.id] += self.get_probablity(lo, r)
        end
        list[lo.id] = list[lo.id].to_f / self.learning_objects.count
      end

      list
    end

    def get_model
      # vytvor model pouzivatela ako postupnost relations
    end

    def get_probability (learning_object, relation)
      # pozri do tabulky na aktualnu hodnotu
    end

  end
end