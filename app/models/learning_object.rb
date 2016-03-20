# Vzdelavaci objekt.
class LearningObject < ActiveRecord::Base
  acts_as_paranoid

  has_many :answers
  has_many :user_to_lo_relations
  has_many :rooms_learning_objects
  has_many :concepts_learning_objects
  has_many :feedbacks
  has_and_belongs_to_many :concepts, -> { uniq }
  belongs_to :course

  include Exceptions

  # Validacie modelu.
  validates_presence_of :lo_id, presence: true
  validates_presence_of :question_text, presence: true
  validates_presence_of :type, presence: true
  validates_presence_of :difficulty, presence: true

  DIFFICULTY = {
    TRIVIAL:    'trivial',          # I'm too young to die
    EASY:       'easy',             # Hey, not too rough
    MEDIUM:     'medium',           # Hurt me plenty
    HARD:       'hard',             # Ultra-Violence
    IMPOSSIBLE: 'impossible',       # Nightmare!
    UNKNOWN:    'unknown_difficulty'
  }

  validates :difficulty, inclusion: { :in => DIFFICULTY.values }

  TYPE = {
      singlechoicequestion: "SingleChoiceQuestion",
      multichoicequestion: "MultiChoiceQuestion",
      evaluatorquestion: "EvaluatorQuestion"
  }

  validates :type, inclusion: { :in => TYPE.values }

  DIFFICULTY_VALUE = {
      trivial: 0.01,
      easy: 0.25,
      medium: 0.5,
      hard: 0.75,
      impossible: 1,
      unknown_difficulty: 0.5
  }
  IMPORTANCE = {  # Toto neviem ake ma hodnoty zatial, treba naimportovat
      EASY: :easy,
      MEDIUM: :medium,
      HARD: :hard,
      UNKNOWN: :unknown_importance
  }

  IMPORTANCE_VALUE = {
      easy: 0,
      medium: 0.5,
      hard: 1,
      UNKNOWN: 0.5
  }

  # generuje metody z hashu DIFFICULTY, napr. 'learning_object.trivial?'
  LearningObject::DIFFICULTY.values.each do |diff|
    define_method("#{diff}?") do
      self.difficulty == "#{diff}"
    end
  end

  def next_in_room(room_id,actual_question_id)
    room = Room.find_by_id(room_id)
    los_not_visited = room.get_not_visited_los
    los_not_visited = los_not_visited.reject{ |los| los.id == actual_question_id}
    los_not_visited.try(:shuffle).try(:first)
  end

  def previous_in_room(room_id)
    Room.find(room_id).learning_objects.where('learning_objects.id < ?', self.id).order(id: :desc).first
  end

  def next(current_user,week_number) # mozno radsej spustit odporucanie.. pri tomto odporucani ani som vsetko nepresla a napisalo ze som na poslednej
    setup = Setup.take
    week = setup.weeks.find_by_number(week_number)
    RecommenderSystem::Recommender.setup(current_user.id,week.id,nil)
    best = RecommenderSystem::HybridRecommender.new.get_best(nil)
    los = LearningObject.find(best[0])
  end

  def previous(week_number)
    Week.find_by_number(week_number).learning_objects.where('learning_objects.id < ?', self.id).order(id: :desc).first
  end

  def seen_by_user(user_id)
    UserVisitedLoRelation.create(user_id: user_id, learning_object_id: self.id, setup_id: 1)
  end

  # Ziska a vypocita informacie o uspesnosti otazky.
  def successfulness

    stats = UserToLoRelation.where(learning_object: self.id).group(:type).count(:id)
    total = stats['UserSolvedLoRelation'].to_i + stats['UserFailedLoRelation'].to_i

    rate = total > 0 ? ((stats['UserSolvedLoRelation'].to_f / total.to_f)*100).round(2) : 0.0
    { solved: stats['UserSolvedLoRelation'], failed: stats['UserFailedLoRelation'], total: total, rate: rate }

  end

  def url_name
    "#{id}-#{lo_id.parameterize}"
  end

  def link_concept(concept)
    self.concepts << concept unless self.concepts.include?(concept)
  end

  # Overi, ci nova odpoved moze byt oznacena ako spravna.
  def allow_new_correctness?
    if type == "SingleChoiceQuestion"
      answers.each do |answer|
        return false if answer.is_correct
      end
    end
    true
  end

  # Overi, ci nova odpoved moze byt oznacena ako viditelna.
  def allow_new_visibility?
    if type == "EvaluatorQuestion"
      answers.each do |answer|
        return false if answer.visible
      end
    end
    true
  end

  # Overi, ci su korektne nastavenie informacie o odpovediach.
  def validate_answers!

    case type
      when "SingleChoiceQuestion"

        correct_answers = 0
        answers.each do |answer|
          correct_answers += 1 if answer.is_correct
          raise AnswersCorrectnessError if correct_answers > 1
        end

      when "EvaluatorQuestion"

        visible_answers = 0
        answers.each do |answer|
          visible_answers += 1 if answer.visible
          raise AnswersVisibilityError if visible_answers > 1
        end

      else
    end

  end

  # Vrati narocnost learning objectu
  def get_difficulty

    #Ziska narocnost zadanu ucitelom
    dif_value = LearningObject::DIFFICULTY_VALUE[(self.difficulty ? self.difficulty.to_sym : :unknown_difficulty)]

    # Vypocita narocnost z interakcii v systeme
    results = Levels::Preproces.preproces_data
    all = 0
    do_not_know_value = 0
    results.each do |r|
      if r[0][1] == self.id
        all +=1
        if r[1] == 0
          do_not_know_value +=1
        end
      end
    end

    # Vypocita vyslednu obtiaznost objektu
    if all == 0
      dif_result = dif_value
    else
      dif_result = (dif_value + (do_not_know_value.to_f / all.to_f)) / 2.0
    end
  end

  # Vrati dolezitost learning objectu
  def get_importance
    LearningObject::IMPORTANCE_VALUE[(self.importance ? self.importance.to_sym : :unknown_importance)]
  end

end
