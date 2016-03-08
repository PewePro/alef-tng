module Levels
  # Trieda sluzi na vytvorenie miestnosti
  class RoomsCreation

    # Metoda vytvori novu miestnost
    def self.create(week_id,user_id)
      if (Week.find(week_id).free_los(nil,user_id).count > Room::NUMBER_LOS_IN_ROOM )
        number_lo = Room::NUMBER_LOS_IN_ROOM
      else
        number_lo = Week.find(week_id).free_los(nil,user_id).count
      end
      setup = Setup.take
      week = Week.find(week_id)
      learning_objects = week.learning_objects.all.distinct

      # Vypocet kolko otazok typu evaluator, resp. choice sa ma do miestnosti vybrat
      sorted_los = Array.new
      number_of_evaluator_q = week.free_los("EvaluatorQuestion",user_id).count
      number_of_choice_q = week.free_los("ChoiceQuestion",user_id).count
      part_evaluator = number_of_evaluator_q.to_f / (number_of_evaluator_q + number_of_choice_q).to_f
      result_number_evaluator = (number_lo * part_evaluator).round

      if (result_number_evaluator > number_of_evaluator_q)
        evaluator = number_of_evaluator_q
      else
        evaluator = result_number_evaluator
      end
      choice = number_lo - evaluator
      if (choice > number_of_choice_q)
        choice = number_of_choice_q
      end
      unless evaluator + choice == number_lo
        if number_of_evaluator_q > evaluator
          evaluator +=1
        elsif number_of_evaluator_q > choice
          choice +=1
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

      # Vypocet score a vytvorenie miestnosti
      score_limit = Levels::ScoreCalculation.compute_limit_score(number_lo,sorted_los,setup)
      name = "Test #{week.number.to_s}.#{(week.rooms.where(user_id: user_id).count + 1).to_s} "

      room = Room.create(:name => name,:week_id => week.id, :user_id => user_id, :score => 0.0, :number_of_try => 0, :score_limit => score_limit)

      sorted_los.each do |l|
        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
      end

      room.id
    end

  end
end


