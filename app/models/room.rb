
class Room < ActiveRecord::Base
  belongs_to :week
  belongs_to :user
  has_many :rooms_learning_objects
  has_many :user_to_lo_relation
  has_many :learning_objects, through: :rooms_learning_objects

  def question_count
    self.learning_objects.all.distinct.count
  end

  def question_count_done user_id
    lo_ids = self.learning_objects.all.distinct.map(&:id)
    UserSolvedLoRelation.where(learning_object_id: lo_ids, user_id: user_id).
        group(:learning_object_id).count.
        count
  end

  def question_count_not_visited room_id
    @results=RoomsLearningObject.get_id_do_not_viseted(room_id).count
  end

  def next(user_id,week_id)
    Room.where('id > ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :asc).first
  end

  def previous(user_id,week_id)
    Room.where('id < ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :desc).first
  end

  def answered (lo_id, room_id)
    @results=RoomsLearningObject.get_id_do_not_viseted(room_id)
    @results.each do |r|
      if lo_id == r['learning_object_id'].to_i
        return true
      end
    end
    false
  end

end