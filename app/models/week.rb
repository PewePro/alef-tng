class Week < ActiveRecord::Base
  belongs_to :setup
  has_and_belongs_to_many :concepts
  has_many :rooms
  has_many :concepts_weeks
  has_many :learning_objects, through: :concepts

  # Rozhodne o tom, ci ma byt dany tyzden spristupneny pre studenta.
  #
  # @return [Boolean] true, ak ma byt tyzden viditelny pre studentov
  def is_visible?
    setup.show_all? || Date.today >= start_at
  end

  # Ziska nasledujuci tyzden v poradi.
  # Ak ide o tyzden, ktory nie je pristupny (buducnost), metoda vracia nil.
  #
  # @return [Week] instancia nasledujuceho tyzdna
  def next
    week = Week.where('number > ? AND setup_id = ?', self.number, self.setup_id).order(number: :asc).first
    week && week.is_visible? ? week : nil
  end

  def previous
    Week.where('number < ? AND setup_id = ?', self.number, self.setup_id).order(number: :desc).first
  end

  def question_count
    self.learning_objects.all.distinct.count
  end

  def question_count_done user_id
    lo_ids = self.learning_objects.all.distinct.map(&:id)
    UserSolvedLoRelation.where(learning_object_id: lo_ids, user_id: user_id).
        group(:learning_object_id).count.
        count
  end

  # Vrati ocakavany pocet miestnosti v tyzdni
  def rooms_count user_id
    count = self.rooms.where("user_id = ?", user_id).count
    free_los = free_los(nil, user_id).count
    count + (free_los / Room::NUMBER_LOS_IN_ROOM.to_f).ceil
  end

  # Vrati pocet uspesne prejdenych miestnosti v danom tyzdni pre konkretneho pouzivatela
  def rooms_count_done user_id
    rooms = self.rooms.where("user_id = ?", user_id).order(state: :asc, id: :asc)
    rooms.where(state: "used").count
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

  # Vrati zoznam zatial nezaradenych otazok do miestnosti v danom tyzdni pre konkretneho pouzivatela
  def free_los (type_question, user_id)
    if type_question.nil?
      los_week = self.learning_objects.distinct
      los_in_rooms = LearningObject.joins(rooms_learning_objects: :room).where("rooms.week_id = ? AND rooms.user_id = ?", self.id,user_id)
    elsif type_question == "EvaluatorQuestion"
      los_week = self.learning_objects.where("learning_objects.type = ?","EvaluatorQuestion").distinct
      los_in_rooms = LearningObject.joins(rooms_learning_objects: :room).where("rooms.week_id = ? AND rooms.user_id = ? AND learning_objects.type = ?", self.id,user_id,"EvaluatorQuestion")
    else
      los_week = self.learning_objects.where("learning_objects.type != ?","EvaluatorQuestion").distinct
      los_in_rooms = LearningObject.joins(rooms_learning_objects: :room).where("rooms.week_id = ? AND rooms.user_id = ? AND learning_objects.type != ?", self.id,user_id,"EvaluatorQuestion")
    end
    los_week.reject{ |los| los_in_rooms.include?(los)}
  end

  before_destroy do |week|
    Concept.all.each do |concept|
      concept.weeks.delete(week)
    end
  end

end