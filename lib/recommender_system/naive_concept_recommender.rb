# Tento odporucac sa snazi pouzivatelovi ponuknut otazky, ktore este nevidel alebo neriesil
module RecommenderSystem
  class NaiveConceptRecommender < RecommenderSystem::Recommender

    # Kolko ostatnych aktivity sa berie do uvahy
    @@history = 5

    def get_list

      # Zober poslednych X relations z otazok z daneho tyzdna
      top_relations = self.relations.select do |x|
        x.type == "UserSolvedLoRelation" or
            x.type == "UserFailedLoRelation" or
            x.type == "UserDidntKnowLoRelation"
      end.reverse.first(@@history)

      los = LearningObject.where('id IN (?)', top_relations.map(&:learning_object_id)).includes(:concepts)

      # Vytvor hash, kde sa zaznaci kolko z tych otazok sa tykalo ktorych konceptov
      concepts = Hash.new
      los.each do |lo|
        lo.concepts.each do |c|
            if concepts[c.id].nil?
              concepts[c.id] = 1
            else
              concepts[c.id] += 1
            end
        end
      end

      # Ohodnot otazky z tyzdna na zaklade toho, kolko ich konceptov bolo pouzitych nedavno
      list = Hash.new
      self.learning_objects.each do |lo|
        list[lo.id] = 0
        lo.concepts.each do |c|
          unless concepts[c.id].nil?
            list[lo.id] += concepts[c.id].to_f / @@history
          end
        end
      end


      list
    end


  end
end