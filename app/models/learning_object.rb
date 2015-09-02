class LearningObject < ActiveRecord::Base
  has_many :answers
  has_many :user_to_lo_relations
  has_many :feedbacks
  has_and_belongs_to_many :concepts, -> { uniq }
  belongs_to :course

  DIFFICULTY = {
    TRIVIAL: :trivial,       # I'm too young to die
    EASY: :easy,             # Hey, not too rough
    MEDIUM: :medium,         # Hurt me plenty
    HARD: :hard,             # Ultra-Violence
    IMPOSSIBLE: :impossible, # Nightmare!
    UNKNOWN: :unknown_difficulty
  }

  # Generuje metody User.rola? zo zoznamu roli
  LearningObject::DIFFICULTY.values.each do |diff|
    define_method("#{diff}?") do
      self.difficulty == "#{diff}"
    end
  end
  def next(week_number)
    Week.find_by_number(week_number).learning_objects.where('learning_objects.id > ?', self.id).order(id: :asc).first
  end

  def previous(week_number)
    Week.find_by_number(week_number).learning_objects.where('learning_objects.id < ?', self.id).order(id: :desc).first
  end

  def seen_by_user(user_id)
    UserVisitedLoRelation.create(user_id: user_id, learning_object_id: self.id, setup_id: 1)
  end

  def url_name
    "#{id}-#{lo_id.parameterize}"
  end

  def link_concept(concept)
    self.concepts << concept unless self.concepts.include?(concept)
  end

end