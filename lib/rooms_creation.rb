#module Levels
  class RoomsCreation
    def create(week_number)
      number_lo = 10
      @setup = Setup.take
      @week = @setup.weeks.find_by_number(week_number)
      learning_objects = @week.learning_objects.all.distinct
      number = learning_objects.count / number_lo
      if learning_objects.count % number_lo > 0
        number+=1
      end
      p number_lo.to_s + " " + number.to_s
      order = (0..(learning_objects.count-1)).to_a
      order = order.shuffle

      j=0
      for i in 1..number
        name = "Miestnosť č. " + i.to_s
        room = Room.create(:name => name,:week_id => @week.id)

        if i!=number || (i==number && (learning_objects.count % number_lo == 0))
          for m in 1..number_lo
            l = learning_objects[order[j].to_i]
            p l.id
            j+=1
           RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
          end
        else
          for m in 1..(learning_objects.count % number_lo)
            l = learning_objects[order[j].to_i]
            p l.id
            j+=1
             RoomsLearningObject.create(:room_id => room.id,:learning_object_id => l.id)
          end
        end

      end
    end

  end
#end


rooms = RoomsCreation.new
rooms.create(1)
