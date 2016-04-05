module Levels
  # Trieda sluzi na vytvorenie miestnosti
  class RoomsCreation

    # Metoda vytvori novu miestnost
    #
    # @param week_id [Integer] cislo tyzdna
    # @param user_id [Integer] identifikator pouzivatela
    # @return [Integer] vracia ID miestnosti, ak (Vytvori miestnost s dostatocnym poctom learning objektov), inak vrati prazdny identifikator (nil)
    def self.create(week_id,user_id)

      week = Week.find(week_id)
      learning_objects = week.learning_objects.all.distinct

      unless week.free_los("EvaluatorQuestion",user_id).count == 0

        # Vypocet kolko otazok typu evaluator, resp. choice sa ma do miestnosti vybrat
        sorted_los = Array.new
        number_of_evaluator_q = week.free_los("EvaluatorQuestion",user_id).count
        number_of_choice_q = week.free_los("ChoiceQuestion",user_id).count

        if number_of_evaluator_q > Constants::NUMBER_EVALUATOR_LOS_IN_ROOM # Do miestnosti sa priradi stanoveny pocet evaluator question a ak ich tolko nie je, tak pocet kolko ich dany tyzden ma
          evaluator = Constants::NUMBER_EVALUATOR_LOS_IN_ROOM
        else
          evaluator = number_of_evaluator_q
        end

        if (number_of_choice_q > (Room::NUMBER_LOS_IN_ROOM - evaluator)) # Zvysok sa doplni choice, opat ak ich tolko je, tak sa doplni do poctu miestnosti, inak len tolko, kolko ich tyzden ma
          choice = Room::NUMBER_LOS_IN_ROOM - evaluator
        else
          choice = number_of_choice_q
        end

        # Ak dokopy otazky v miestnosti nedavaju minimum a zaroven existuju este volne evaluator question je nimi miestnost doplnena
        if (choice + evaluator < Room::NUMBER_LOS_IN_ROOM && number_of_evaluator_q > Constants::NUMBER_EVALUATOR_LOS_IN_ROOM)
          if (number_of_evaluator_q + choice  > Room::NUMBER_LOS_IN_ROOM)
            evaluator = Room::NUMBER_LOS_IN_ROOM - choice
          else
            evaluator = number_of_evaluator_q
          end
        end

        # Vyber otazok typu evaluator
        if (evaluator > 0)
          RecommenderSystem::Recommender.setup(user_id,week_id,"EvaluatorQuestion")
          recommendations = RecommenderSystem::HybridRecommender.new.get_list

          recommendations.each do |key, value|
            sorted_los << learning_objects.find {|l| l.id == key}
          end

          sorted_los = sorted_los[0..(evaluator -1)]
        end

        # Vyber otazok typu choice
        if (choice > 0)
          RecommenderSystem::Recommender.setup(user_id,week_id,"ChoiceQuestion")
          recommendations = RecommenderSystem::HybridRecommender.new.get_list

          sorted_los2 = Array.new
          recommendations.each do |key, value|
            sorted_los2 << learning_objects.find {|l| l.id == key}
          end
          sorted_los2 = sorted_los2[0..(choice -1)]
          sorted_los = sorted_los + sorted_los2
        end

        unless sorted_los.count == 0

          # Vypocet score a vytvorenie miestnosti
          score_limit = Levels::ScoreCalculation.compute_limit_score(sorted_los)
          name = "Test #{week.number.to_s}.#{(week.rooms.where(user_id: user_id).count + 1).to_s} "

          room = Room.create(:name => name,:week_id => week.id, :user_id => user_id, :score => 0.0, :number_of_try => 0, :score_limit => score_limit)

          sorted_los.each do |l|
            RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
          end

          return room.id
        end
      end

      nil
    end

  end
end


