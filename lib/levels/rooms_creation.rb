module Levels
  class RoomsCreation
    def self.create(week_id,user_id)
      p user_id
      p week_id
      number_lo = 10
      @setup = Setup.take
      @week = @setup.weeks.find_by_id(week_id)
      learning_objects = @week.learning_objects.all.distinct

      order = (0..(learning_objects.count-1)).to_a
      order = order.shuffle
      order=order[0..(number_lo -1)]

      p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      p order
      j=0

      name = "Miestnosť č. " + (@week.rooms.count + 1).to_s
      room = Room.create(:name => name,:week_id => @week.id, :user_id => user_id, :score => 0.0.to_f, :number_of_try => 0)

     for j in 0..(number_lo-1)
       l = learning_objects[order[j].to_i]
       RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
     end

      room.id
    end
    # def create2(week_number)
    #   number_lo = 10
    #   @setup = Setup.take
    #   @week = @setup.weeks.find_by_number(week_number)
    #   learning_objects = @week.learning_objects.all.distinct
    #   number = learning_objects.count / number_lo
    #   if learning_objects.count % number_lo > 0
    #     number+=1
    #   end
    #   p number_lo.to_s + " " + number.to_s
    #   order = (0..(learning_objects.count-1)).to_a
    #   order = order.shuffle
    #
    #   j=0
    #   for i in 1..number
    #     name = "Miestnosť č. " + i.to_s
    #     room = Room.create(:name => name,:week_id => @week.id)
    #
    #     if i!=number || (i==number && (learning_objects.count % number_lo == 0))
    #       for m in 1..number_lo
    #         l = learning_objects[order[j].to_i]
    #         p l.id
    #         j+=1
    #        RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
    #       end
    #     else
    #       for m in 1..(learning_objects.count % number_lo)
    #         l = learning_objects[order[j].to_i]
    #         p l.id
    #         j+=1
    #          RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
    #       end
    #     end
    #
    #   end
    # end
    #
    # def create1(week_number)
    #   number_lo = 10
    #
    #   # ziskanie lo
    #
    #   @setup = Setup.take
    #   @week = @setup.weeks.find_by_number(week_number)
    #   learning_objects = @week.learning_objects.all.distinct
    #   number = learning_objects.count / number_lo
    #   if learning_objects.count % number_lo > 0
    #     number+=1
    #   end
    #
    #   # zistenie userov
    #
    #   @users = @setup.users.all.distinct
    #
    #   # urcenie obtianosti lo
    #
    #   @results = UserToLoRelation.get_results_lo(week_number)
    #   values = {}
    #   learning_objects.each do |lo|
    #     dif = 0.to_f
    #     if lo.difficulty == "easy".to_s
    #       dif = 1
    #     elsif lo.difficulty == "trivial".to_s
    #       dif = 2
    #     elsif lo.difficulty == "medium".to_s
    #       dif = 3
    #     elsif lo.difficulty == "hard".to_s
    #       dif = 4
    #     elsif lo.difficulty == "very hard".to_s
    #       dif = 5
    #     else
    #       dif = 2.5
    #     end
    #     dif=dif.to_f/5.to_f
    #
    #     result = @results.find {|r| r["result_id"] == lo.id.to_s}
    #
    #     unless result.nil?
    #       solved = result['solved']
    #       failed = result['failed']
    #       donotnow = result['donotnow']
    #     end
    #
    #     dif2=0.5.to_f
    #     if (solved.to_i + failed.to_i + donotnow.to_i) != 0
    #       dif2 = ((solved.to_i + failed.to_i + donotnow.to_i)-solved.to_i).to_f / (solved.to_i + failed.to_i + donotnow.to_i).to_f
    #     end
    #     difficulty = (dif + dif2)/2
    #
    #     values[lo.id]= difficulty
    #   end
    #
    #   p values
    #
    #   # urcenie narocnosti konceptov
    #
    #   @concepts = @week.concepts.all.distinct
    #   values_concepts = {}
    #   @concepts.each do |con|
    #
    #     concept_difficulty = 0.to_f
    #     los = con.learning_objects.all.distinct
    #     los.each do |l|
    #       concept_difficulty+=values[l.id]
    #     end
    #     concept_difficulty = concept_difficulty / los.count
    #     values_concepts[con.id] = concept_difficulty
    #   end
    #
    #   p values_concepts
    #
    #   # usporiadat koncepty
    #   values_concepts =  values_concepts.sort_by{|key, value| value}.to_h
    #
    #   p values_concepts
    #
    #
    #
    #
    #   # j=0
    #   # for i in 1..number
    #   #   name = "Miestnosť č. " + i.to_s
    #   #   room = Room.create(:name => name,:week_id => @week.id)
    #   #
    #   #   if i!=number || (i==number && (learning_objects.count % number_lo == 0))
    #   #     for m in 1..number_lo
    #   #       l = learning_objects[order[j].to_i]
    #   #       p l.id
    #   #       j+=1
    #   #       RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
    #   #     end
    #   #   else
    #   #     for m in 1..(learning_objects.count % number_lo)
    #   #       l = learning_objects[order[j].to_i]
    #   #       p l.id
    #   #       j+=1
    #   #       RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
    #   #     end
    #   #   end
    #   #
    #   # end
    # end
  end
end


