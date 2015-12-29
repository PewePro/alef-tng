module Levels
  class RoomsCreation
    def self.create2(week_id,user_id)
      p user_id
      p week_id
      number_lo = 10
      @setup = Setup.take
      @week = @setup.weeks.find_by_id(week_id)
      learning_objects = @week.learning_objects.all.distinct

      order = (0..(learning_objects.count-1)).to_a
      order = order.shuffle
      order=order[0..(number_lo -1)]


      name = "Miestnosť č. " + (@week.rooms.count + 1).to_s
      room = Room.create(:name => name,:week_id => @week.id, :user_id => user_id, :score => 0.0.to_f, :number_of_try => 0)

     for j in 0..(number_lo-1)
       l = learning_objects[order[j].to_i]
       RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
     end

      room.id
    end

    def self.compute_limit(number_lo)
      weight_solved = 5
      number_questions = 6

      score_limit = 0.0

      sum_dif = 0
      sum_imp = 0

      for i in 0..(number_lo-1)
        l = @sorted_los[i]
        p l.id
        lo = LearningObject.where("id = ?", l.id).first

        dif = lo.difficulty.to_s
        dif_value = 0
        imp = lo.importance.to_s
        imp_value = 0

        p dif.to_s + "    " + imp.to_s

        if dif.to_s == "easy"
          dif_value = 1
        elsif dif.to_s == "trivial"
          dif_value = 2
        elsif dif.to_s == "medium"
          dif_value = 3
        elsif dif.to_s == "hard"
          dif_value = 4
        elsif dif.to_s == "very hard"
          dif_value = 5
        else
          dif_value = 3
        end

        sum_dif +=dif_value

        if imp.to_s == "1"
          imp_value = 1
        elsif imp.to_s == "2"
          imp_value = 2
        elsif imp.to_s == "3"
          imp_value = 3
        else
          imp_value = 2
        end

        sum_imp +=imp_value

      end

      avg_dif = sum_dif.to_f / number_lo.to_f
      avg_imp = sum_imp.to_f / number_lo.to_f

      avg_dif = avg_dif.to_f / 3
      avg_imp = avg_imp.to_f / 2

      score_limit = number_questions * weight_solved * avg_imp * avg_dif

      score_limit
    end
    def self.prepare_description(number_lo)
      description = "Najviac zastúpené koncepty: "
      number = 5
      list = Hash.new

      for i in 0..(number_lo-1)
        l = @sorted_los[i]
        p l.id
        lo = LearningObject.where("id = ?", l.id).first
        concepts = lo.concepts
        concepts.each do |c|
          if !(list.has_key?(c.name.to_s))
            list[c.name.to_s] = 1
          else
            list[c.name.to_s] = list[c.name.to_s].to_i + 1
          end
        end
      end

      list = list.sort_by{|_key, value| value}.reverse.to_h

      if list.length < number
        number = list.length.to_i
      end


      for i in 0..(number - 1)
        if i!= (number-1)
          description = description + list.keys[i] + " => " + list.values[i].to_s + " krát, "
        else
          description = description + list.keys[i] + " => " + list.values[i].to_s + " krát."
        end
      end

      p "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      p description

      description
    end

    def self.create(week_id,user_id)
      p user_id
      p week_id
      number_lo = 10
      @setup = Setup.take
      @week = @setup.weeks.find_by_id(week_id)
      learning_objects = @week.learning_objects.all.distinct

      RecommenderSystem::Recommender.setup(user_id,week_id)
      recommendations = RecommenderSystem::HybridRecommender.new.get_list


      @sorted_los = Array.new
      recommendations.each do |key, value|
        @sorted_los << learning_objects.find {|l| l.id == key}
      end

      @sorted_los = @sorted_los[0..(number_lo -1)]

      score_limit = compute_limit(number_lo)
      name = "Miestnosť " + @week.number.to_s + "." + (@week.rooms.where(user_id: user_id).count + 1).to_s
      description = prepare_description(number_lo)

      room = Room.create(:name => name,:week_id => @week.id, :user_id => user_id, :score => 0.0.to_f, :number_of_try => 0, :score_limit => score_limit, :decsription => description)

      for j in 0..(number_lo-1)
        l = @sorted_los[j]
        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
       end

      room.id
    end

  end
end


