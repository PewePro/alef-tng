class Week < ActiveRecord::Base
  belongs_to :setup
  has_and_belongs_to_many :concepts
  has_many :learning_objects, through: :concepts

  def next
    Week.where('number > ? AND setup_id = ?', self.number, self.setup_id).order(number: :asc).first
  end

  def previous
    Week.where('number < ? AND setup_id = ?', self.number, self.setup_id).order(number: :desc).first
  end

  def question_count
    self.learning_objects.uniq.count
  end

  def question_count_done user_id
    lo_ids = self.learning_objects.uniq.map(&:id)
    UserSolvedLoRelation.where(learning_object_id: lo_ids, user_id: user_id).
        group(:learning_object_id).count.
        count
  end

  def start_at
    self.setup.first_week_at.to_date + self.number * 7 - 7
  end

  def end_at
    self.start_at + 6
  end

  def actual?
    (Date.today-self.start_at).to_i.between?(0,6)
  end

  before_destroy do |week|
    Concept.all.each do |concept|
      concept.weeks.delete(week)
    end
  end

end