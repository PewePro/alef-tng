module Levels
  class RoomsCreation
    def self.compute_limit(number_lo, learning_objects,setup)

      number_questions = number_lo * ENV["MIN_PERCENTAGE"].to_f

      sum_dif = 0.0
      sum_imp = 0.0

      learning_objects.each do |l|
        dif_result = l.get_difficulty(setup)
        sum_dif += dif_result
        imp_value = l.get_importance
        sum_imp += imp_value
      end

      avg_dif = sum_dif / number_lo.to_f
      avg_imp = sum_imp / number_lo.to_f

      number_questions * ENV["WEIGHT_SOLVED"].to_i * avg_imp * avg_dif

    end

    def self.create(week_id,user_id)
      if (Week.find(week_id).free_los(nil,user_id).count > ENV["NUMBER_LOS"].to_i )
        number_lo = ENV["NUMBER_LOS"].to_i
      else
        number_lo = Week.find(week_id).free_los(nil,user_id).count
      end
      setup = Setup.take
      week = Week.find(week_id)
      learning_objects = week.learning_objects.all.distinct

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

      if (evaluator > 0)
        RecommenderSystem::Recommender.setup(user_id,week_id,"EvaluatorQuestion")
        recommendations = RecommenderSystem::HybridRecommender.new.get_list

        recommendations.each do |key, value|
          sorted_los << learning_objects.find {|l| l.id == key}
        end

        sorted_los = sorted_los[0..(evaluator -1)]
      end

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

      score_limit = compute_limit(number_lo,sorted_los,setup)
      name = "Test #{week.number.to_s}.#{(week.rooms.where(user_id: user_id).count + 1).to_s} "

      room = Room.create(:name => name,:week_id => week.id, :user_id => user_id, :score => 0.0, :number_of_try => 0, :score_limit => score_limit)

      sorted_los.each do |l|
        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
      end

      room.id
    end

  end
end


