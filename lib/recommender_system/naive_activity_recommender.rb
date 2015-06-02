# Tento odporucac sa snazi pouzivatelovi ponuknut otazky, ktore este nevidel alebo neriesil
module RecommenderSystem
class NaiveActivityRecommender < RecommenderSystem::Recommender

  def get_list

    # najdi vsekty interakcie pouzivatela s otazkami z daneho tyzdna
    list = Hash.new
    self.learning_objects.each do |lo|
      list[lo.id] = 1
    end

    # pre kazdu otazku najdi interakciu s najnizsim skore
    self.relations.each do |rel|
      value = self.evaluate_relation(rel)
      if list[rel.learning_object_id] > value
        list[rel.learning_object_id] = value
      end
    end

    self.relations.last(20).map(&:id).uniq do |id|
      list[id] -= 0.2
    end

    normalize list
  end

  def evaluate_relation (relation)
    case relation.class.name
      when 'UserVisitedLoRelation'
        0.8
      when 'UserViewedSolutionLoRelation'
        0.6
      when 'UserDidntKnowLoRelation', 'UserFailedLoRelation'
        0.4
      else
        0.2
    end
  end

end
end