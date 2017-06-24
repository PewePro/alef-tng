class Week < ActiveRecord::Base
  belongs_to :setup
  has_and_belongs_to_many :concepts
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