# Tento odporucac sa snazi pouzivatelovi ponuknut otazky, ktore este nevidel alebo neriesil
module RecommenderSystem
  class NaiveConceptRecommender < RecommenderSystem::Recommender

    def get_list

      list = Hash.new

      top_relations = self.relations.select do |x|
        x.type == "UserSolvedLoRelation" or
        x.type == "UserFailedLoRelation" or
        x.type == "UserDidntKnowLoRelation"
      end.reverse.first(5)

      los = LearningObject.where('id IN (?)',top_relations.map(&:id)).includes(:concepts)

      list
    end



  end
end