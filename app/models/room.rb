
class Room < ActiveRecord::Base
  belongs_to :week
  belongs_to :user
  has_many :rooms_learning_objects
  has_many :user_to_lo_relation
  has_many :learning_objects, through: :rooms_learning_objects

  # The number of los in room
  NUMBER_LOS_IN_ROOM = 10
  # The number of the most used concepts in a room that is shown in description
  NUMBER_OF_CONCEPTS_IN_DESCRIPTION = 5


  # Vrati learning objecty, ktore v danom pokuse a miestnosti este neboli videne
  def get_not_visited_los
    visited_los = self.learning_objects.eager_load(:user_to_lo_relations).where("user_to_lo_relations.room_id = ? AND user_to_lo_relations.number_of_try = ?",self.id,self.number_of_try)
    los = self.learning_objects
    los_result = los.reject{ |l| visited_los.include?(l) }
    los_result
  end

  def question_count
    self.learning_objects.count
  end

  # Vrati pocet vyriesenych otazok v danej miestnosti
  def question_count_done user_id
    lo_ids = self.learning_objects.map(&:id)
    p "aaaa"
    pom =  UserSolvedLoRelation.where(learning_object_id: lo_ids, user_id: user_id).
        group(:learning_object_id).count.count
    p pom
  end

  def question_count_not_visited
    self.get_not_visited_los.count
  end

  def next (user_id,week_id)
    Room.where('id > ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :asc).first
  end

  def previous (user_id,week_id)
    Room.where('id < ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :desc).first
  end

  # Vrati hodnotu, ci dana otazka bola alebo nebola zodpovedana
  def not_answered (lo_id)
    get_not_visited_los.map(&:id).include?(lo_id)
  end

end