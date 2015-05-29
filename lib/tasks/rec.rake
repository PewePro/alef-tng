namespace :alef do
  namespace :rec do

    desc 'Vymaze nastavenia opdorucacieho systemu'
    task :remove_configuration => :environment do

      RecommendersOption.delete_all
      RecommendationLinker.delete_all
      RecommendationConfiguration.delete_all
      Recommender.delete_all

    end

    desc 'Nastavi odporucac pre zakladny test ActivityRecommendera'
    task :create_default_setup => :environment do

      # Zaregistruje jednotlive odporucace
      Rake::Task["alef:rec:register_recommenders"].reenable
      Rake::Task["alef:rec:register_recommenders"].invoke

      # Vytvori nastavenia
      confDefault = RecommendationConfiguration.create(name: 'default', default: true)
      confAlter = RecommendationConfiguration.create(name: 'alternative')

      # Spoji pouzivatelov s konkretnym nastavenim pre dany tyzden
      weeks = Setup.take.weeks
      User.all.each do |u|
        if u.id % 2 == 1
          weeks.each do |w|
            RecommendationLinker.create(user_id: u.id, recommendation_configuration_id: confAlter.id, week_id: w.id)
          end
        end
      end

      # Najde zelane opdorucace
      activityRec = Recommender.where(name: 'Activity').take
      naiveActivityRec = Recommender.where(name: 'NaiveActivity').take
      naiveConceptRec = Recommender.where(name: 'NaiveConcept').take


      # Nastavi ich vahu pre jednotlive odporucania
      RecommendersOption.create(recommendation_configuration_id: confDefault.id, recommender_id: naiveActivityRec.id, weight: 10)
      RecommendersOption.create(recommendation_configuration_id: confDefault.id, recommender_id: naiveConceptRec.id, weight: 5)

      RecommendersOption.create(recommendation_configuration_id: confAlter.id, recommender_id: naiveActivityRec.id, weight: 8)
      RecommendersOption.create(recommendation_configuration_id: confAlter.id, recommender_id: naiveConceptRec.id, weight: 3)
      RecommendersOption.create(recommendation_configuration_id: confAlter.id, recommender_id: activityRec.id, weight: 3)

      # Spracuje tabulku pre activity recommender
      RecommenderSystem::ActivityRecommender.update_table

    end

    desc 'Vytvori tabulku odporucacov'
    task :register_recommenders => :environment do
      Recommender.create(name: 'Activity')
      Recommender.create(name: 'NaiveActivity')
      Recommender.create(name: 'NaiveConcept')
    end

  end
end
