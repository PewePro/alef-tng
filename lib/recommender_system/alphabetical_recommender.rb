module RecommenderSystem
class AlphabeticalRecommender < RecommenderSystem::Recommender
  def get_list

    los = self.learning_objects.sort_by {|x| x.lo_id}

    list = Hash.new
    i = 0
    los.each do |lo|
      list[lo.id] = i.to_f / los.count
      i += 1
    end

    list
  end
end
end