module Levels
  class RoomsCreation
    def self.compute_limit(number_lo, learning_objects,setup)
      weight_solved = 5
      number_questions = number_lo * 0.6

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
          dif_value = 0.5
        else
          if dif == "trivial"
            dif_value = 0.01
          elsif dif == "easy"
            dif_value = 0.25
          elsif dif == "medium"
            dif_value = 0.5
          elsif dif == "hard"
            dif_value = 0.75
          elsif dif == "impossible"
            dif_value = 1.0
          else
            dif_value = 0.5
          end
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

        if all!= 0
          dif_compute = do_not_know_value.to_f / all.to_f
          dif_result = (dif_value + dif_compute) / 2.0
        else
          dif_result = dif_value
        end

        sum_dif +=dif_result

        if dif.nil?
          imp_value = 0.5
        else
          if imp == "1"
            imp_value = 0.0
          elsif imp == "2"
            imp_value = 0.5
          elsif imp == "3"
            imp_value = 1
          else
            imp_value = 0.5
          end
        end

        sum_imp +=imp_value

      end

      avg_dif = sum_dif / number_lo.to_f
      avg_imp = sum_imp / number_lo.to_f

      number_questions * weight_solved * avg_imp * avg_dif

    end
    def self.prepare_description(number_lo,sorted_los)
      description = "Najviac zastúpené témy: "
      number = 5
      list = Hash.new

      for i in 0..(number_lo-1)
        l = sorted_los[i]
        lo = LearningObject.where("id = ?", l.id).first
        concepts = lo.concepts
        concepts.each do |c|
          if list.has_key?(c.name)
            list[c.name] = list[c.name].to_i + 1
          else
            list[c.name] = 1
          end
        end
      end

      list = list.sort_by{|_key, value| value}.reverse.to_h

      if list.length < number
        number = list.length
      end


      for i in 0..(number - 1)
        if i!= (number-1)
          description = description + list.keys[i] + " => " + list.values[i].to_s + " krát, "
        else
          description = description + list.keys[i] + " => " + list.values[i].to_s + " krát."
        end
      end

      description
    end

    def self.create(week_id,user_id)
      if (Week.find(week_id).free_los(user_id).count > 10 )
        number_lo = 10
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
      if (evaluator + choice != number_lo)
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
      description = prepare_description(number_lo,sorted_los)

      room = Room.create(:name => name,:week_id => week.id, :user_id => user_id, :score => 0.0, :number_of_try => 0, :score_limit => score_limit, :decsription => description)

      for j in 0..(number_lo-1)
        l = sorted_los[j]
        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
       end

      room.id
    end

  end
end


