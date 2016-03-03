module Levels
  class RoomsCreation
    def self.compute_limit(number_lo, learning_objects,setup)

      number_questions = number_lo * ENV["MIN_PERCENTAGE"].to_f

      sum_dif = 0.0
      sum_imp = 0.0

      for i in 0..(number_lo-1)
        l = learning_objects[i]
        lo = LearningObject.where("id = ?", l.id).first

        dif = lo.difficulty
        dif_value = 0
        imp = lo.importance
        imp_value = 0

        if dif.nil?
          dif_value = LearningObject::DIFFICULTY_VALUE["unknown_difficulty".to_sym]
        else
          dif_value = LearningObject::DIFFICULTY_VALUE[dif.to_sym]
        end

        dif_compute = 0.0
        dif_result = 0.0
        results = Levels::Preproces.preproces_data(setup)

        all = 0
        do_not_know_value = 0
        results.each do |r|
          if r[0][1] == lo.id
            all +=1
            if r[1] == 0
              do_not_know_value +=1
            end
          end
        end

        if all== 0
          dif_result = dif_value
        else
          dif_compute = do_not_know_value.to_f / all.to_f
          dif_result = (dif_value + dif_compute) / 2.0
        end

        sum_dif += dif_result

        if imp.nil?
          imp_value = LearningObject::DIFFICULTY_VALUE["UNKNOWN".to_sym]
        else
          imp_value = LearningObject::IMPORTANCE_VALUE[imp.to_sym]
        end

        sum_imp += imp_value

      end

      avg_dif = sum_dif / number_lo.to_f
      avg_imp = sum_imp / number_lo.to_f

      number_questions * ENV["WEIGHT_SOLVED"].to_i * avg_imp * avg_dif

    end

    def self.create(week_id,user_id)
      if (Week.find(week_id).free_los(user_id).count > ENV["NUMBER_LOS"].to_i )
        number_lo = ENV["NUMBER_LOS"].to_i
      else
        number_lo = Week.find(week_id).free_los(user_id).count
      end
      setup = Setup.take
      week = setup.weeks.find_by_id(week_id)
      learning_objects = week.learning_objects.all.distinct

      sorted_los = Array.new
      number_of_evaluator_q = week.free_los_by_type_of_question("EvaluatorQuestion",user_id).count
      number_of_choice_q = week.free_los_by_type_of_question("ChoiceQuestion",user_id).count
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
      name = "Test " + week.number.to_s + "." + (week.rooms.where(user_id: user_id).count + 1).to_s

      room = Room.create(:name => name,:week_id => week.id, :user_id => user_id, :score => 0.0, :number_of_try => 0, :score_limit => score_limit)

      for j in 0..(number_lo-1)
        l = sorted_los[j]
        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
       end

      room.id
    end

  end
end


