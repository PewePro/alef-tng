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
      conf_default = RecommendationConfiguration.create(name: 'default', default: true)
      conf_alter = RecommendationConfiguration.create(name: 'alternative')

      # Spoji pouzivatelov s konkretnym nastavenim pre dany tyzden
=begin
      weeks = Setup.take.weeks
      User.all.each do |u|
        if u.id % 2 == 1
          weeks.each do |w|
            RecommendationLinker.create(user_id: u.id, recommendation_configuration_id: conf_alter.id, week_id: w.id)
          end
        end
      end
=end

      # Najde zelane opdorucace
      activity_rec = Recommender.where(name: 'Activity').take
      naive_activity_rec = Recommender.where(name: 'NaiveActivity').take
      naive_concept_rec = Recommender.where(name: 'NaiveConcept').take
      irt_rec = Recommender.where(name: 'Irt').take


      # Nastavi ich vahu pre jednotlive odporucania
      RecommendersOption.create(recommendation_configuration_id: conf_default.id, recommender_id: naive_activity_rec.id, weight: 2)
      RecommendersOption.create(recommendation_configuration_id: conf_default.id, recommender_id: irt_rec.id, weight: 1)


      # Spracuje tabulku pre activity recommender
      RecommenderSystem::ActivityRecommender.update_table

    end

    desc 'Vytvori tabulku odporucacov'
    task :register_recommenders => :environment do
      Recommender.create(name: 'Activity')
      Recommender.create(name: 'NaiveActivity')
      Recommender.create(name: 'NaiveConcept')
      Recommender.create(name: 'Irt')
    end

  end
end
