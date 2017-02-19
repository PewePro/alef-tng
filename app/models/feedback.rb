class Feedback < ActiveRecord::Base
  before_create :increment_number_of_feedbacks, :update_comment_time
  before_destroy :decrement_number_of_feedbacks
  before_update :increment_number_of_feedbacks, :if => "visible_changed? && visible_was == false"
  before_update :decrement_number_of_feedbacks, :if => "visible_changed? && visible_was == true"

  after_update :update_comment_time_if_neccesary
  after_destroy :update_comment_time_if_neccesary

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

  def update_comment_time
    self.learning_object.update!(last_comment_time: Time.now())
  end

  def update_comment_time_if_neccesary
    newest_comment = self.learning_object.feedbacks.where('visible = True').order(created_at: :desc).first
    unless newest_comment.nil?
      self.learning_object.update!(last_comment_time: newest_comment.created_at)
    end
  end

end