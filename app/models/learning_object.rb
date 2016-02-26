class LearningObject < ActiveRecord::Base
  has_many :answers
  has_many :user_to_lo_relations
  has_many :rooms_learning_objects
  has_many :irt_values
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

  # generuje metody z hashu DIFFICULTY, napr. 'learning_object.trivial?'
  LearningObject::DIFFICULTY.values.each do |diff|
    define_method("#{diff}?") do
      self.difficulty == "#{diff}"
    end
  end
  def next(room_id,actual_question_id)
    id_array = []
    @results=RoomsLearningObject.get_id_do_not_viseted_minus_actual(room_id,actual_question_id)
    @results.each do |r|
      id_array.push(r['learning_object_id'].to_i)
    end
    @room = Room.find(room_id)

    if !(id_array.empty?)
      los = @room.learning_objects.find(id_array[Random.rand(0..(id_array.count-1))])
    else
      los = nil
    end

    los
  end

  def previous(room_id)
    Room.find(room_id).learning_objects.where('learning_objects.id < ?', self.id).order(id: :desc).first
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
