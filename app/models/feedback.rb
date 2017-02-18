class Feedback < ActiveRecord::Base
  before_create :increment_number_of_feedbacks
  before_destroy :decrement_number_of_feedbacks
  before_update :increment_number_of_feedbacks, :if => "visible_changed? && visible_was == false"
  before_update :decrement_number_of_feedbacks, :if => "visible_changed? && visible_was == true"

  belongs_to :user
  belongs_to :learning_object
  scope :not_reviewed, -> { where(accepted: nil) }
  scope :visible, -> { where(visible: true) }

  def url_path
    URI.parse(self.url).path
  end

  def increment_number_of_feedbacks
    self.learning_object.increment!(:comment_number, by = 1)
  end

  def decrement_number_of_feedbacks
    self.learning_object.decrement!(:comment_number, by = 1)
  end

end