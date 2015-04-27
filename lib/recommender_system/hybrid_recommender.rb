module RecommenderSystem
  class HybridRecommender < RecommenderSystem::Recommender

  def self.get_list (user_id, week_id)

    # Najde prislusnu konfiguraciu odporucania
    linker = RecommendationLinker.find_by(user_id: user_id, week_id: week_id)
    if linker.nil?
      config = RecommendationConfiguration.find_by_default(true)
    else
      config = RecommendationConfiguration.find(linker.recommendation_configuration_id)
    end

    # Vytvori list, do ktoreho sa budu ukladat vysledky odporucani
    list = Hash.new
    self.learning_objects(week_id).ids.uniq.each do |id|
      list[id] = 0
    end

    # Necha prebehnut vsetky odporucace a ich vysledky zratava dokopy
    unless config.nil? or config.recommenders_options.nil?
      config.recommenders_options.each do |r|
        r_class = Object.const_get "#{r.recommender.name.capitalize}Recommender"
        result = r_class.get_list(user_id,week_id)
        result.each do |id, value|
          list[id] += value * r.weight
        end
      end
    end

    # Vrati vysledny list
    list.sort_by { |_, value| value }
  end

  end
end