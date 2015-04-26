class RecommendationSystem

  def self.get_list (user_id, week_id)
    id = RecommendationLinker.find_by(user_id: user_id, week_id: week_id).recommendation_configuration_id
    config = RecommendationConfiguration.find(id)

    config.recommenders_options.each do |r|
      puts r.recommender.name
      puts r.weight
    end
    # get recommendation config
    # compute all recs
    # reduce and return
  end

  def self.get_best (user_id, week_id)
    self.get_list(user_id, week_id).first
  end

end