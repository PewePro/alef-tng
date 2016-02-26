class RoomsLearningObject < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :room

 def self.get_id_do_not_viseted_minus_actual(room_id,actual_question_id)

   room = Room.find(room_id)
   number_of_try = room.number_of_try
   sql = '
   (SELECT rooms_learning_objects.learning_object_id
   FROM "rooms_learning_objects"
   WHERE rooms_learning_objects.room_id = '+room_id.to_s+' AND rooms_learning_objects.learning_object_id != '+actual_question_id.to_s+' )
   EXCEPT
   (SELECT user_to_lo_relations.learning_object_id
   FROM "user_to_lo_relations"
   WHERE user_to_lo_relations.room_id = '+room_id.to_s+' AND user_to_lo_relations.number_of_try = '+number_of_try.to_s+'
   GROUP BY user_to_lo_relations.learning_object_id)'

   ActiveRecord::Base.connection.execute(sql)
 end

  def self.get_id_do_not_viseted(room_id)

     room = Room.find(room_id)
     number_of_try = room.number_of_try
     sql = '
   (SELECT rooms_learning_objects.learning_object_id
   FROM "rooms_learning_objects"
   WHERE rooms_learning_objects.room_id = '+room_id.to_s+' )
   EXCEPT
   (SELECT user_to_lo_relations.learning_object_id
   FROM "user_to_lo_relations"
   WHERE user_to_lo_relations.room_id = '+room_id.to_s+' AND user_to_lo_relations.number_of_try = '+number_of_try.to_s+'
   GROUP BY user_to_lo_relations.learning_object_id)'

     ActiveRecord::Base.connection.execute(sql)
  end
end
