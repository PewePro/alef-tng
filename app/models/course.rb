class Course < ActiveRecord::Base
  has_many :setups
  has_many :concepts
  has_many :learning_objects

  # Ziska zoznam otazok, ku ktorym nebol vyrieseny nejaky feedback.
  def feedbackable_questions(limit = 10)
    Feedback.where(accepted: nil, learning_object_id: learning_objects.pluck(:id))
        .pluck(:learning_object_id).sample(limit)
  end

end