
class Room < ActiveRecord::Base
  belongs_to :week
  belongs_to :user
  has_many :rooms_learning_objects
  has_many :user_to_lo_relation
  has_many :learning_objects, through: :rooms_learning_objects

  def get_dont_visited
    visited_los = self.learning_objects.eager_load(:user_to_lo_relations).where("user_to_lo_relations.room_id = ? AND user_to_lo_relations.number_of_try = ?",self.id,self.number_of_try)
    los = self.learning_objects
    los_result = los.reject{ |l| visited_los.include?(l) }
    los_result
  end

  def question_count
    self.learning_objects.count
  end

  def question_count_done user_id
    lo_ids = self.learning_objects.map(&:id)
    UserSolvedLoRelation.where(learning_object_id: lo_ids, user_id: user_id).
        group(:learning_object_id).count.
        count
  end

  def question_count_not_visited
    @results=self.get_dont_visited.count
  end

  def next (user_id,week_id)
    Room.where('id > ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :asc).first
  end

  def previous (user_id,week_id)
    Room.where('id < ? AND user_id = ? AND week_id = ?', self.id,user_id,week_id).order(id: :desc).first
  end

  def not_answered (lo_id)
    los =  self.get_dont_visited
    (los.map { |l| l.id == lo_id }).include?(true)
  end

end