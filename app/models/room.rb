
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

  def next
    Room.where('id > ?', self.id).order(id: :asc).first
  end

  def previous
    Room.where('id < ?', self.id).order(id: :desc).first
  end

  def otvorena?
    self.state=="otvorena"
  end

end