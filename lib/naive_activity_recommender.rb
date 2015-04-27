# Tento odporucac sa snazi pouzivatelovi ponuknut otazky, ktore este nevidel alebo neriesil

class NaiveActivityRecommender < AbstractRecommender

  def self.get_list (user_id, week_id)

    # najdi vsekty interakcie pouzivatela s otazkami z daneho tyzdna
    los = self.learning_objects(week_id)
    relations = UserToLoRelation.where('user_id = (?) AND learning_object_id IN (?)', user_id, los.map(&:id))

    list = Hash.new
    los.each do |lo|
      list[lo.id] = 1
    end

    relations.each do |rel|
      value = self.evaluate_relation(rel)
      if list[rel.learning_object_id] > value
        list[rel.learning_object_id] = value
      end
    end

    list
  end

  def self.evaluate_relation (relation)
    case relation.class.name
      when 'UserVisitedLoRelation'
        0.75
      when 'UserViewedSolutionLoRelation'
        0.5
      when 'UserDidntKnowLoRelation', 'UserFailedLoRelation'
        0.25
      else
        0
    end
  end

end