class Week < ActiveRecord::Base
  belongs_to :setup
  has_and_belongs_to_many :concepts
  has_many :rooms
  has_many :learning_objects, through: :concepts

  def next
    Week.where('number > ? AND setup_id = ?', self.number, self.setup_id).order(number: :asc).first
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

  def rooms_count
    if (self.learning_objects.distinct.count % ENV["NUMBER_LOS"].to_i == 0)
      count = (self.learning_objects.distinct.count / ENV["NUMBER_LOS"].to_i).to_i
    else
      count = (self.learning_objects.distinct.count / ENV["NUMBER_LOS"].to_i).to_i + 1
    end
    count
  end

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

  def free_los user_id
    sql = '(SELECT DISTINCT learning_objects.* FROM learning_objects
     INNER JOIN concepts_learning_objects ON learning_objects.id = concepts_learning_objects.learning_object_id
     INNER JOIN concepts ON concepts_learning_objects.concept_id = concepts.id
     INNER JOIN concepts_weeks ON concepts.id = concepts_weeks.concept_id
     WHERE concepts_weeks.week_id = '+self.id.to_s+')
     except
     (SELECT DISTINCT learning_objects.* FROM learning_objects
     INNER JOIN rooms_learning_objects ON learning_objects.id = rooms_learning_objects.learning_object_id
     INNER JOIN rooms ON rooms_learning_objects.room_id = rooms.id
     WHERE rooms.week_id = '+self.id.to_s+' AND rooms.user_id = '+user_id.to_s+');'

    LearningObject.find_by_sql(sql.to_s)
  end

  def free_los_by_type_of_question (type_question, user_id)
    type = "EvaluatorQuestion"
    if (type_question.to_s == type)

      sql = "(SELECT DISTINCT learning_objects.* FROM learning_objects
       INNER JOIN concepts_learning_objects ON learning_objects.id = concepts_learning_objects.learning_object_id
       INNER JOIN concepts ON concepts_learning_objects.concept_id = concepts.id
       INNER JOIN concepts_weeks ON concepts.id = concepts_weeks.concept_id
       WHERE concepts_weeks.week_id = "+self.id.to_s+" AND learning_objects.type = '#{type}')
       except
       (SELECT DISTINCT learning_objects.* FROM learning_objects
       INNER JOIN rooms_learning_objects ON learning_objects.id = rooms_learning_objects.learning_object_id
       INNER JOIN rooms ON rooms_learning_objects.room_id = rooms.id
       WHERE rooms.week_id = "+self.id.to_s+" AND learning_objects.type = '#{type}' AND rooms.user_id = "+user_id.to_s+");"
    else
      sql = "(SELECT DISTINCT learning_objects.* FROM learning_objects
       INNER JOIN concepts_learning_objects ON learning_objects.id = concepts_learning_objects.learning_object_id
       INNER JOIN concepts ON concepts_learning_objects.concept_id = concepts.id
       INNER JOIN concepts_weeks ON concepts.id = concepts_weeks.concept_id
       WHERE concepts_weeks.week_id = "+self.id.to_s+" AND learning_objects.type != '#{type}')
       except
       (SELECT DISTINCT learning_objects.* FROM learning_objects
       INNER JOIN rooms_learning_objects ON learning_objects.id = rooms_learning_objects.learning_object_id
       INNER JOIN rooms ON rooms_learning_objects.room_id = rooms.id
       WHERE rooms.week_id = "+self.id.to_s+" AND learning_objects.type != '#{type}' AND rooms.user_id = "+user_id.to_s+");"
    end

    LearningObject.find_by_sql(sql.to_s)
  end

  before_destroy do |week|
    Concept.all.each do |concept|
      concept.weeks.delete(week)
    end
  end

end