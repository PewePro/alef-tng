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

  before_destroy do |week|
    Concept.all.each do |concept|
      concept.weeks.delete(week)
    end
  end

end